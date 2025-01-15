#!/bin/bash

# =============================================================================
# Phase 2.3: Extract and Setup Files
# =============================================================================

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/postimage/common.sh"

# Exit on error
set -e

TEMP_DIR="/tmp/heethings_downloads"
BASE_DIR="/home/pi/Heethings"
CC_DIR="$BASE_DIR/CC"

log "INFO" "Starting file extraction process..."

# Function to clean macOS metadata folders
clean_macos_folders() {
    local dir="$1"
    if [ -d "$dir/__MACOSX" ]; then
        log "INFO" "Cleaning macOS metadata folder from $dir"
        rm -rf "$dir/__MACOSX"
    fi
}

# Ensure CC directory exists
log "INFO" "Ensuring directories exist..."
mkdir -p "$CC_DIR/application"
mkdir -p "$CC_DIR/elevator/app"
mkdir -p "$CC_DIR/diagnose/app"

# Copy sensor.zip to CC directory
log "INFO" "Copying sensor package..."
if [ ! -f "$TEMP_DIR/sensor.zip" ]; then
    log "ERROR" "sensor.zip not found in $TEMP_DIR"
    exit 1
fi
cp "$TEMP_DIR/sensor.zip" "$CC_DIR/"
chmod 644 "$CC_DIR/sensor.zip"

# Extract Flutter apps
log "INFO" "Extracting Flutter applications..."

# Extract CC app
log "INFO" "Extracting CC application..."
if [ ! -f "$TEMP_DIR/cc.zip" ]; then
    log "ERROR" "cc.zip not found in $TEMP_DIR"
    exit 1
fi

if ! unzip -o "$TEMP_DIR/cc.zip" -d "$CC_DIR/application" 2> /tmp/unzip_error.log; then
    log "ERROR" "Failed to extract CC application. Error: $(cat /tmp/unzip_error.log)"
    exit 1
fi
clean_macos_folders "$CC_DIR/application"
log "INFO" " CC application extracted successfully"

# Extract Elevator app
log "INFO" "Extracting CC-Elevator application..."
if [ ! -f "$TEMP_DIR/elevator.zip" ]; then
    log "ERROR" "elevator.zip not found in $TEMP_DIR"
    exit 1
fi

if ! unzip -o "$TEMP_DIR/elevator.zip" -d "$CC_DIR/elevator/app" 2> /tmp/unzip_error.log; then
    log "ERROR" "Failed to extract CC-Elevator application. Error: $(cat /tmp/unzip_error.log)"
    exit 1
fi
clean_macos_folders "$CC_DIR/elevator/app"
log "INFO" " CC-Elevator application extracted successfully"

# Extract Diagnose app
log "INFO" "Extracting CC-Diagnose application..."
if [ ! -f "$TEMP_DIR/diagnose.zip" ]; then
    log "ERROR" "diagnose.zip not found in $TEMP_DIR"
    exit 1
fi

if ! unzip -o "$TEMP_DIR/diagnose.zip" -d "$CC_DIR/diagnose/app" 2> /tmp/unzip_error.log; then
    log "ERROR" "Failed to extract CC-Diagnose application. Error: $(cat /tmp/unzip_error.log)"
    exit 1
fi
clean_macos_folders "$CC_DIR/diagnose/app"
log "INFO" " CC-Diagnose application extracted successfully"

# Set permissions
log "INFO" "Setting file permissions..."
chmod -R 755 "$CC_DIR"
chown -R pi:pi "$CC_DIR"

# Clean up
log "INFO" "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"
rm -f /tmp/unzip_error.log

# Final cleanup of any remaining macOS metadata folders
clean_macos_folders "$CC_DIR"
clean_macos_folders "$BASE_DIR"

log "INFO" "File extraction and setup completed successfully"
