#!/bin/bash

# Exit on any error
set -e

# Function to handle errors
handle_error() {
    echo "Error: Build failed at line $1"
    # Cleanup on error
    if [ -d "$BUILD_DIR" ]; then
        rm -rf "$BUILD_DIR"
    fi
    exit 1
}

# Set error trap
trap 'handle_error $LINENO' ERR

# Default values
APPLICATION="app"
BRANCH="main"
SOURCE_PATH=""
DEFAULT_FILENAME=""
FTP_HOST="217.195.206.12"
FTP_USER="ilker.okutman"
FTP_PASS="Peb79/^PaL&vDt"
API_URL="https://chc-api.globeapp.dev"
API_KEY="b75a185c-0cb9-4223-86b9-90a1a85d3b48"
GITHUB_TOKEN=""
TOKEN_FILE="/home/pi/github-token.txt"

# Function to print usage
print_usage() {
    echo "Usage: $0 [--application=[app|admin|diagnose|elevator]] [--branch=BRANCH] [--token=GITHUB_TOKEN]"
    echo "Example: $0 --application=diagnose --branch=feature/something"
    echo "Note: If token is not provided, it will be read from $TOKEN_FILE"
    echo "Defaults: application=app, branch=main"
    exit 1
}

# Parse command line arguments
for i in "$@"; do
    case $i in
        --application=*)
        APPLICATION="${i#*=}"
        shift
        ;;
        --branch=*)
        BRANCH="${i#*=}"
        shift
        ;;
        --token=*)
        GITHUB_TOKEN="${i#*=}"
        shift
        ;;
        *)
        echo "Unknown parameter: $i"
        print_usage
        ;;
    esac
done

# If token not provided and not building main app, try to read from file
if [ "$APPLICATION" != "app" ] && [ -z "$GITHUB_TOKEN" ]; then
    if [ -f "$TOKEN_FILE" ]; then
        GITHUB_TOKEN=$(cat "$TOKEN_FILE")
        echo "Using GitHub token from $TOKEN_FILE"
    else
        echo "Error: GitHub token is required for $APPLICATION"
        echo "Either provide --token parameter or create $TOKEN_FILE"
        exit 1
    fi
fi

# Validate application parameter and set corresponding paths
case $APPLICATION in
    "app")
        SOURCE_PATH="/home/pi/Heethings/CC/source/hee_rsp_central-heating-control"
        DEFAULT_FILENAME="heethings-cc"
        REPO_URL="https://github.com/Performans-Dev/hee_rsp_central-heating-control.git"
        ;;
    "admin")
        SOURCE_PATH="/home/pi/Heethings/CC-Admin/source/hee_rsp_chc-admin"
        DEFAULT_FILENAME="cc-admin"
        REPO_URL="https://${GITHUB_TOKEN}@github.com/Performans-Dev/hee_rsp_chc-admin.git"
        ;;
    "diagnose")
        SOURCE_PATH="/home/pi/Heethings/CC-Diagnose/source/hee_rsp_cc-diagnose"
        DEFAULT_FILENAME="cc-diagnose"
        REPO_URL="https://${GITHUB_TOKEN}@github.com/Performans-Dev/hee_rsp_cc-diagnose.git"
        ;;
    "elevator")
        SOURCE_PATH="/home/pi/Heethings/CC-Elevator/source/hee_rsp_chc-updater"
        DEFAULT_FILENAME="cc-elevator"
        REPO_URL="https://${GITHUB_TOKEN}@github.com/Performans-Dev/hee_rsp_chc-updater.git"
        ;;
    *)
        echo "Error: Invalid application: $APPLICATION"
        exit 1
        ;;
esac

echo "Building $APPLICATION from branch $BRANCH"

# Create build directory
BUILD_DIR="/tmp/build_$APPLICATION"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Clone and checkout branch
echo "Cloning repository..."
if ! git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$BUILD_DIR"; then
    echo "Error: Failed to clone repository"
    exit 1
fi

cd "$BUILD_DIR" || exit 1

# Get version information from pubspec.yaml
echo "Reading version from pubspec.yaml"
pubspec_yaml_path="$BUILD_DIR/pubspec.yaml"
if [ ! -f "$pubspec_yaml_path" ]; then
    echo "Error: pubspec.yaml not found at $pubspec_yaml_path"
    exit 1
fi

version=$(grep -i version "$pubspec_yaml_path" | sed 's/^\s*//; s/\s*$//' | awk -F ':' '{print $2}')
if [ -z "$version" ]; then
    echo "Error: Failed to extract version from pubspec.yaml"
    exit 1
fi

VERSION_NUMBER=$(echo "$version" | cut -d '+' -f 1 | xargs)
VERSION_CODE=$(echo "$version" | cut -d '+' -f 2)

# If version code contains dots, convert it to integer
if [[ $VERSION_CODE == *"."* ]]; then
    VERSION_CODE=$(echo "$VERSION_CODE" | awk -F. '{ printf "%d%02d%02d", $1, $2, $3 }' | sed 's/^0*//')
fi

if [ -z "$VERSION_NUMBER" ] || [ -z "$VERSION_CODE" ]; then
    echo "Error: Invalid version format in pubspec.yaml"
    exit 1
fi

echo "Version Number: $VERSION_NUMBER"
echo "Version Code: $VERSION_CODE"

# Build for ARM64
echo "Building Flutter application..."
flutter channel stable
# Check flutter installation
flutter doctor -v || true

# Critical build steps
if ! flutter clean; then
    echo "Error: Flutter clean failed"
    exit 1
fi

if ! flutter pub get; then
    echo "Error: Flutter pub get failed"
    exit 1
fi

if ! flutter analyze; then
    echo "Error: Flutter analyze failed"
    exit 1
fi

if ! flutter build linux --release --target-platform=linux-arm64; then
    echo "Error: Flutter build failed"
    exit 1
fi

# Create bundle directory
BUNDLE_DIR="$BUILD_DIR/bundle"
mkdir -p "$BUNDLE_DIR"

# Copy build artifacts
if ! cp -r build/linux/arm64/release/bundle/* "$BUNDLE_DIR/"; then
    echo "Error: Failed to copy build artifacts"
    exit 1
fi

# Create zip file
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ZIP_FILENAME="${DEFAULT_FILENAME}_${VERSION_NUMBER}_${TIMESTAMP}.zip"
cd "$BUNDLE_DIR" || exit 1
if ! zip -r "$ZIP_FILENAME" ./*; then
    echo "Error: Failed to create zip file"
    exit 1
fi

# Upload to FTP
echo "Uploading to FTP..."
if ! ftp -n <<EOF
open $FTP_HOST
user $FTP_USER $FTP_PASS
cd api2.run/releases.api2.run/heethings/cc
put $ZIP_FILENAME
bye
EOF
then
    echo "Error: FTP upload failed"
    exit 1
fi

# Register new version
echo "Registering new version..."
RELEASE_URL="https://releases.api2.run/heethings/cc/$ZIP_FILENAME"
echo "Sending version data:"
echo "  Version Code: $VERSION_CODE"
echo "  Version Number: $VERSION_NUMBER"
echo "  URL: $RELEASE_URL"
echo "  Application: $APPLICATION"

RESPONSE=$(curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "x-api-key: $API_KEY" \
    -d "{\"version_code\": $VERSION_CODE, \"version_number\": \"$VERSION_NUMBER\", \"url\": \"$RELEASE_URL\", \"application\": \"$APPLICATION\"}" \
    "$API_URL/api/v1/settings/app/version/add")

if [[ $(echo "$RESPONSE" | grep -c "success") -eq 0 ]]; then
    echo "Error: Failed to register version"
    echo "Response: $RESPONSE"
    exit 1
fi

echo "Build completed successfully!"

# Cleanup
rm -rf "$BUILD_DIR"
