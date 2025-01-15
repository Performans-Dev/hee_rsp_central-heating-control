#!/bin/bash

# =============================================================================
# Phase 2.1: Directory Structure Setup
# =============================================================================

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/postimage/common.sh"

# Exit on error
set -e

log "INFO" "Setting up directory structure..."

# Base directories
BASE_DIR="/home/pi/Heethings"
CC_DIR="$BASE_DIR/CC"

# Create main directories (use -p to avoid errors if they exist)
log "INFO" "Creating main directories..."
mkdir -p "$BASE_DIR"            # Base directory
mkdir -p "$CC_DIR"             # CC directory
mkdir -p "$CC_DIR/application"    # Main flutter app CC
mkdir -p "$CC_DIR/elevator/app"   # Flutter app CC-Elevator
mkdir -p "$CC_DIR/diagnose/app"   # Flutter app CC-Diagnose
mkdir -p "$CC_DIR/logs"          # Logs folder
mkdir -p "$CC_DIR/databases"     # Databases folder
mkdir -p "$CC_DIR/sensor"        # Sensor scripts and data
mkdir -p "$CC_DIR/sensor/script" # Sensor Python scripts
mkdir -p "$CC_DIR/sensor/sensor_env" # Virtual environment
mkdir -p "$CC_DIR/sensor/data"   # Sensor data files
mkdir -p "/home/pi/Pictures"     # Pictures directory

# Preserve existing database files if they exist
if [ -d "$CC_DIR/databases" ] && [ ! -z "$(ls -A "$CC_DIR/databases")" ]; then
    log "INFO" "Preserving existing database files..."
    chmod -R 644 "$CC_DIR/databases"/*
fi

# Set correct permissions
log "INFO" "Setting directory permissions..."
chown -R pi:pi "$BASE_DIR"
chown -R pi:pi "/home/pi/Pictures"
chmod -R 755 "$CC_DIR"

log "INFO" "Directory structure setup completed!"
