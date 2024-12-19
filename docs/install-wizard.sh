#!/bin/bash

# Ensure we're running with GUI
if [ -z "$DISPLAY" ]; then
    echo "This installer requires a graphical environment"
    exit 1
fi

# Function to show error dialog
show_error() {
    zenity --error \
        --title="Installation Error" \
        --width=400 \
        --text="$1"
}

# Function to show progress
show_progress() {
    zenity --progress \
        --title="Heethings Installation" \
        --text="$1" \
        --pulsate \
        --auto-close \
        --no-cancel
}

# Welcome screen
zenity --info \
    --title="Heethings Installation Wizard" \
    --width=500 \
    --text="Welcome to the Heethings Central Heating Control installation wizard.\n\nThis will guide you through the installation process.\n\nBefore continuing, please ensure:\n- The Raspberry Pi is connected to the internet\n- The touchscreen is properly connected\n- You have at least 30 minutes for the installation" \
    --ok-label="Next >" || exit 1

# Check internet connection
echo "Checking internet connection..." | show_progress
if ! ping -c 1 google.com >/dev/null 2>&1; then
    show_error "No internet connection detected.\nPlease connect to the internet and try again."
    exit 1
fi

# Confirm installation
zenity --question \
    --title="Ready to Install" \
    --width=400 \
    --text="The system is ready to begin installation.\n\nThis process will:\n- Configure system settings\n- Install required packages\n- Set up the touchscreen\n- Configure VNC access\n\nThe system will reboot during installation.\nDo you want to continue?" \
    --ok-label="Install" \
    --cancel-label="Cancel" || exit 1

# Create a log viewer
tail -f /var/log/heethings_setup.log | zenity --text-info \
    --title="Installation Progress" \
    --width=600 \
    --height=400 \
    --auto-scroll \
    --ok-label="Hide" \
    --cancel-label="Stop Installation" &
LOG_VIEWER_PID=$!

# Start the actual installation script
sudo bash raspberry-install-script.sh

# Kill the log viewer
kill $LOG_VIEWER_PID 2>/dev/null

exit 0
