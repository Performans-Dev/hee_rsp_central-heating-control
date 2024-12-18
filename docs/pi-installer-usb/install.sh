#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG_FILE="/var/log/heethings_setup.log"

# Function to show progress dialog
show_progress() {
    zenity --progress \
        --title="Heethings Installation" \
        --text="$1" \
        --percentage=0 \
        --auto-close \
        --pulsate
}

# Function to show error
show_error() {
    zenity --error \
        --title="Installation Error" \
        --width=400 \
        --text="$1"
    exit 1
}

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Welcome screen
zenity --info \
    --title="Heethings Installation" \
    --width=500 \
    --text="Welcome to Heethings Central Heating Control Installation\n\nThis wizard will:\n\n1. Install required software\n2. Configure system settings\n3. Set up the control application\n4. Configure auto-start service\n\nClick OK to begin." \
    || exit 1

# Check internet connection
echo "Checking internet connection..." | show_progress
if ! ping -c 1 google.com >/dev/null 2>&1; then
    show_error "No internet connection detected.\nPlease connect to the internet and try again."
fi

# Installation steps confirmation
zenity --question \
    --title="Begin Installation" \
    --width=400 \
    --text="The installer will now:\n\n1. Create application directory (/opt/heethings)\n2. Install the control application\n3. Configure system service\n4. Set up auto-start\n\nDo you want to continue?" \
    --ok-label="Install" \
    --cancel-label="Cancel" \
    || exit 1

# Create progress log window
tail -f "$LOG_FILE" | zenity --text-info \
    --title="Installation Progress" \
    --width=600 \
    --height=400 \
    --auto-scroll \
    --ok-label="Hide" \
    --cancel-label="Stop Installation" &
LOG_VIEWER_PID=$!

# Start installation
log "Starting installation..."

# Step 1: Create application directory
log "Creating application directory..."
sudo mkdir -p /opt/heethings
sudo chown pi:pi /opt/heethings

# Step 2: Copy application files
log "Installing application files..."
sudo cp -r "$SCRIPT_DIR/app"/* /opt/heethings/
sudo chmod +x /opt/heethings/cc

# Step 3: Install system service
log "Setting up system service..."
sudo cp "$SCRIPT_DIR/services/cc.service" /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable cc.service

# Step 4: Configure application
log "Configuring application..."
if [ -f "$SCRIPT_DIR/config/config.json" ]; then
    sudo cp "$SCRIPT_DIR/config/config.json" /opt/heethings/
fi

# Final verification
log "Verifying installation..."
if ! systemctl is-enabled cc.service >/dev/null 2>&1; then
    show_error "Service installation failed. Please check the logs."
fi

# Kill log viewer
kill $LOG_VIEWER_PID 2>/dev/null

# Show completion dialog
zenity --info \
    --title="Installation Complete" \
    --width=400 \
    --text="Installation completed successfully!\n\nThe system needs to reboot to complete the setup.\n\nClick OK to reboot now." \
    && sudo reboot

exit 0
