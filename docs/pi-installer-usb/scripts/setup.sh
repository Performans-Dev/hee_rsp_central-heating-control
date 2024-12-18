#!/bin/bash

# Source utility scripts
source "$SCRIPT_DIR/scripts/network-check.sh"

# Initialize logging
LOG_FILE="/var/log/heethings_setup.log"

# Logging function
log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
    
    # Report progress to GUI if running in display mode
    if [ -n "$DISPLAY" ]; then
        case "$level" in
            "INFO")
                echo "# $message"
                ;;
            "WARN")
                echo "# WARNING: $message"
                ;;
            "ERROR")
                echo "# ERROR: $message"
                DISPLAY=:0 zenity --error --title="Installation Error" --text="$message"
                ;;
        esac
    fi
}

# Error handler
handle_error() {
    local exit_code=$?
    local line_number=$1
    if [ $exit_code -ne 0 ]; then
        log "ERROR" "Error occurred in script at line $line_number"
        exit $exit_code
    fi
}
trap 'handle_error ${LINENO}' ERR

# Set system locale
log "INFO" "Setting system locale..."
sudo raspi-config nonint do_change_locale en_US.UTF-8
sudo raspi-config nonint do_configure_keyboard us

# Set timezone
log "INFO" "Setting timezone..."
sudo raspi-config nonint do_change_timezone Europe/Istanbul

# Enable interfaces
log "INFO" "Enabling required interfaces..."
sudo raspi-config nonint do_ssh 0
sudo raspi-config nonint do_vnc 0
sudo raspi-config nonint do_spi 0
sudo raspi-config nonint do_i2c 0
sudo raspi-config nonint do_serial 0
sudo raspi-config nonint do_rgpio 0

# Disable unnecessary interfaces
sudo raspi-config nonint do_serial_minimal 1
sudo raspi-config nonint do_onewire 1

# Set up display and VNC
log "INFO" "Setting up display and VNC..."
source "$SCRIPT_DIR/scripts/display-setup.sh"
setup_display

# Install service
log "INFO" "Installing system service..."
sudo cp "$SCRIPT_DIR/services/cc.service" /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable cc.service

# Final verification
log "INFO" "Running final verification..."
if systemctl is-enabled cc.service >/dev/null 2>&1; then
    log "INFO" "Auto-start service successfully configured"
else
    log "WARN" "Auto-start service might not be properly configured"
fi

# Show completion dialog
if [ -n "$DISPLAY" ]; then
    DISPLAY=:0 zenity --info \
        --title="Installation Complete" \
        --width=400 \
        --text="Installation has completed successfully!\n\nWould you like to reboot now?" \
        --ok-label="Reboot" \
        --cancel-label="Later"
    
    if [ $? -eq 0 ]; then
        log "INFO" "Rebooting system..."
        sudo reboot now
    else
        log "INFO" "Please remember to reboot your system when convenient"
    fi
fi
