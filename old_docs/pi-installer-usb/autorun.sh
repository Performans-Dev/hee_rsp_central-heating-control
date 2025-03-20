#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Function to show notification
show_notification() {
    if command -v notify-send >/dev/null 2>&1; then
        DISPLAY=:0 notify-send -u normal "Heethings Installer" "$1"
    fi
}

# Make sure we're running as pi user
if [ "$(whoami)" != "pi" ]; then
    echo "This script must run as pi user"
    exit 1
fi

# Ensure we're running in a graphical environment
if [ -z "$DISPLAY" ]; then
    # Wait for display to be available (up to 30 seconds)
    for i in {1..30}; do
        if [ -n "$DISPLAY" ]; then
            break
        fi
        export DISPLAY=:0
        sleep 1
    done
fi

# Install required packages if not present
if ! command -v zenity >/dev/null 2>&1; then
    show_notification "Installing required packages..."
    sudo apt-get update
    sudo apt-get install -y zenity libnotify-bin
fi

# Show autorun notification
show_notification "Starting Heethings installation wizard..."

# Make the installer executable (if needed)
chmod +x "$SCRIPT_DIR/install.sh"

# Launch the installer
if [ -n "$DISPLAY" ]; then
    "$SCRIPT_DIR/install.sh"
else
    echo "No display detected. Please run install.sh manually."
fi
