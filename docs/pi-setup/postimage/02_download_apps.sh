#!/bin/bash

# =============================================================================
# Phase 2.2: Download Applications
# =============================================================================

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/postimage/common.sh"

# Exit on error
set -e

TEMP_DIR="/tmp/heethings_downloads"
BASE_DIR="/home/pi/Heethings"
CC_DIR="$BASE_DIR/CC"
PICTURES_DIR="/home/pi/Pictures"
BASE_URL="https://releases.api2.run/heethings/cc"
API_URL="https://chc-api.globeapp.dev/api/v1/settings/app/version"

# Create temporary directory
log "INFO" "Creating temporary directory..."
mkdir -p "$TEMP_DIR"
mkdir -p "$PICTURES_DIR"

# Function to download and verify file
download_and_verify() {
    local url="$1"
    local output="$2"
    local name="$3"
    
    log "INFO" "Downloading $name from $url"
    if curl -L -v -o "$output" "$url" 2>> /var/log/heethings_error.log; then
        if [ -f "$output" ]; then
            # Check file size
            size=$(stat -f%z "$output" 2>/dev/null || stat -c%s "$output" 2>/dev/null)
            log "INFO" "Downloaded file size: $size bytes"
            
            # Verify if it's a valid zip file
            if unzip -t "$output" > /dev/null 2>&1; then
                log "INFO" "✓ $name downloaded and verified successfully"
                return 0
            else
                log "ERROR" "Downloaded file is not a valid zip: $name"
                # Print file type for debugging
                file "$output" >> /var/log/heethings_error.log
                return 1
            fi
        else
            log "ERROR" "Download failed - file not created: $output"
            return 1
        fi
    else
        log "ERROR" "Failed to download $name - check /var/log/heethings_error.log for details"
        return 1
    fi
}

# Get latest app versions from API
log "INFO" "Fetching latest app versions..."
API_RESPONSE=$(curl -s "$API_URL")

# Check if API response is valid
if [ "$(echo "$API_RESPONSE" | jq -r '.success')" != "true" ]; then
    log "ERROR" "Failed to get valid response from API"
    echo "$API_RESPONSE" >> /var/log/heethings_error.log
    exit 1
fi

# Extract URLs and version info
CC_URL=$(echo "$API_RESPONSE" | jq -r '.data.app.url')
CC_VERSION=$(echo "$API_RESPONSE" | jq -r '.data.app.version_number')

ELEVATOR_URL=$(echo "$API_RESPONSE" | jq -r '.data.elevator.url')
ELEVATOR_VERSION=$(echo "$API_RESPONSE" | jq -r '.data.elevator.version_number')

DIAGNOSE_URL=$(echo "$API_RESPONSE" | jq -r '.data.diagnose.url')
DIAGNOSE_VERSION=$(echo "$API_RESPONSE" | jq -r '.data.diagnose.version_number')

# Download applications
log "INFO" "Downloading applications..."

# Download CC app
if ! download_and_verify "$CC_URL" "$TEMP_DIR/cc.zip" "CC app version $CC_VERSION"; then
    exit 1
fi

# Download Elevator app
if ! download_and_verify "$ELEVATOR_URL" "$TEMP_DIR/elevator.zip" "CC-Elevator app version $ELEVATOR_VERSION"; then
    exit 1
fi

# Download Diagnose app
if ! download_and_verify "$DIAGNOSE_URL" "$TEMP_DIR/diagnose.zip" "CC-Diagnose app version $DIAGNOSE_VERSION"; then
    exit 1
fi

# Download sensor package
if ! download_and_verify "$BASE_URL/sensor.zip" "$TEMP_DIR/sensor.zip" "Sensor package"; then
    exit 1
fi

# Download and extract images.zip
log "INFO" "Downloading images package..."
if curl -L -v -o "$TEMP_DIR/images.zip" "$BASE_URL/images.zip" 2>> /var/log/heethings_error.log; then
    log "INFO" "✓ Images package downloaded successfully"
    
    # Check file size
    size=$(stat -f%z "$TEMP_DIR/images.zip" 2>/dev/null || stat -c%s "$TEMP_DIR/images.zip" 2>/dev/null)
    log "INFO" "Downloaded images.zip size: $size bytes"
    
    # Verify and extract images.zip
    if ! unzip -t "$TEMP_DIR/images.zip" > /dev/null 2>&1; then
        log "ERROR" "Downloaded images.zip is not a valid zip file"
        file "$TEMP_DIR/images.zip" >> /var/log/heethings_error.log
        exit 1
    fi
    
    # Extract images.zip to base directory
    log "INFO" "Extracting images package..."
    if unzip -o "$TEMP_DIR/images.zip" -d "$BASE_DIR" > /dev/null; then
        log "INFO" "✓ Images extracted successfully"
        
        # Set splash screen and wallpaper
        SPLASH_IMAGE="$BASE_DIR/splash.png"
        if [ -f "$SPLASH_IMAGE" ]; then
            log "INFO" "Setting up splash screen and wallpaper..."
            # Set as boot splash
            sudo cp "$SPLASH_IMAGE" /usr/share/plymouth/themes/pix/splash.png
            
            # Set wallpaper through config file
            mkdir -p /home/pi/.config/pcmanfm/LXDE-pi
            cat > /home/pi/.config/pcmanfm/LXDE-pi/desktop-items-0.conf << EOF
[*]
wallpaper_mode=stretch
wallpaper=$SPLASH_IMAGE
desktop_bg=#000000
desktop_fg=#ffffff
desktop_shadow=#000000
show_wm_menu=0
show_documents=0
show_trash=0
show_mounts=0
desktop_fg_alpha=100
desktop_bg_alpha=100
desktop_shadow_alpha=100
EOF
            chown -R pi:pi /home/pi/.config/pcmanfm
        else
            log "ERROR" "Splash image not found after extraction"
            exit 1
        fi
    else
        log "ERROR" "Failed to extract images package"
        exit 1
    fi
else
    log "ERROR" "Failed to download images package - check /var/log/heethings_error.log for details"
    exit 1
fi

# Download wallpapers
log "INFO" "Downloading wallpapers..."
for i in {1..19}; do
    # Format number with leading zero
    num=$(printf "%02d" $i)
    if ! curl -L -v -o "$PICTURES_DIR/wp${num}.jpg" "$BASE_URL/images/wp${num}.jpg" 2>> /var/log/heethings_error.log; then
        log "ERROR" "Failed to download wallpaper wp${num}.jpg - check /var/log/heethings_error.log for details"
        exit 1
    fi
done

# Create version info file
log "INFO" "Creating version info file..."
cat > "$CC_DIR/versions.txt" << EOF
CC App: $CC_VERSION
CC-Elevator: $ELEVATOR_VERSION
CC-Diagnose: $DIAGNOSE_VERSION
Installation Date: $(date '+%Y-%m-%d %H:%M:%S')
EOF

# List downloaded files for verification
log "INFO" "Verifying downloaded files..."
ls -l "$TEMP_DIR" >> /var/log/heethings_install.log

log "INFO" "All downloads completed successfully"
