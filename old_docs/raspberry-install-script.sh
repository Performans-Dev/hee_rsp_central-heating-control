#!/bin/bash

# Script to set up the Heethings project on a fresh Raspbian system
# Includes RTC setup, package installations, folder creation, downloading and extracting zips, and enabling auto-start.

# Error handling
set -e  # Exit on errors
trap 'handle_error $? $LINENO $BASH_LINENO "$BASH_COMMAND" $(printf "::%s" ${FUNCNAME[@]:-})' ERR

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
    local exit_code=$1
    local line_no=$2
    local bash_lineno=$3
    local last_command=$4
    local func_trace=$5
    log "ERROR" "Error $exit_code occurred on line $line_no"
    log "ERROR" "Command: $last_command"
    log "ERROR" "Function trace: $func_trace"
}

# Download function with retry and verification
download_with_retry() {
    local url=$1
    local output=$2
    local max_attempts=3
    local attempt=1

    while [ $attempt -le $max_attempts ]; do
        log "INFO" "Downloading $url (attempt $attempt/$max_attempts)"
        if wget -q --show-progress "$url" -O "$output"; then
            if [ -f "$output" ] && [ -s "$output" ]; then
                log "INFO" "Successfully downloaded $url"
                return 0
            fi
        fi
        log "WARN" "Download attempt $attempt failed, retrying..."
        ((attempt++))
        sleep 5
    done
    log "ERROR" "Failed to download $url after $max_attempts attempts"
    return 1
}

# Verify downloaded zip
verify_zip() {
    local zip_file=$1
    if ! unzip -t "$zip_file" > /dev/null 2>&1; then
        log "ERROR" "Zip file $zip_file is corrupted"
        return 1
    fi
    return 0
}

# Detect environment
is_ssh_session() {
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        return 0  # true
    else
        return 1  # false
    fi
}

# Variables
BASE_DIR="/home/pi/Heethings"
CONFIG_FILE="/boot/firmware/config.txt"
MODULES_FILE="/etc/modules"
HW_CLOCK_FILE="/lib/udev/hwclock-set"
API_URL="https://chc-api.globeapp.dev/api/v1/settings/app/version"
IMAGES_ZIP="https://releases.api2.run/heethings/cc/images.zip"
SENSOR_ZIP="https://releases.api2.run/heethings/cc/sensor.zip"
SCRIPTS_ZIP="https://releases.api2.run/heethings/cc/scripts.zip"
STEP_FILE="/var/tmp/setup_step"
PICTURES_DIR="/home/pi/Pictures"
LOG_FILE="/var/log/heethings_setup.log"
BACKUP_DIR="/home/pi/Heethings_backup"

# Create log file if it doesn't exist
touch "$LOG_FILE"

# Check if running in SSH session
if is_ssh_session; then
    log "INFO" "Running in SSH session"
    export DEBIAN_FRONTEND=noninteractive  # Prevent interactive prompts
else
    log "INFO" "Running in local session"
fi

# Wait for network connectivity
wait_for_network() {
    local max_attempts=30
    local attempt=1
    log "INFO" "Waiting for network connectivity..."
    while [ $attempt -le $max_attempts ]; do
        if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
            log "INFO" "Network is available"
            return 0
        fi
        log "INFO" "Waiting for network... attempt $attempt/$max_attempts"
        sleep 2
        ((attempt++))
    done
    log "ERROR" "Network not available after $max_attempts attempts"
    return 1
}

# Resume script at the correct step
if [ -f "$STEP_FILE" ]; then
    STEP=$(cat "$STEP_FILE")
    log "INFO" "Resuming from step $STEP"
else
    STEP=0
    log "INFO" "Starting fresh installation"
fi

case $STEP in
  0)
    # Configure System Locale and Timezone
    log "INFO" "Configuring system locale and timezone..."
    
    # Set Timezone
    log "INFO" "Setting timezone to Europe/Istanbul..."
    sudo timedatectl set-timezone Europe/Istanbul
    
    # Configure Locale
    log "INFO" "Configuring locale to en_US.UTF-8..."
    sudo sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen
    sudo locale-gen
    sudo update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
    
    # Configure Keyboard
    log "INFO" "Setting keyboard layout to US..."
    sudo sed -i 's/XKBLAYOUT=.*/XKBLAYOUT="us"/' /etc/default/keyboard
    sudo sed -i 's/XKBVARIANT=.*/XKBVARIANT=""/' /etc/default/keyboard
    sudo dpkg-reconfigure -f noninteractive keyboard-configuration
    sudo service keyboard-setup restart
    
    # Verify configurations
    log "INFO" "Verifying system configurations..."
    locale_status="Locale: $(locale | grep LANG=)"
    timezone_status="Timezone: $(timedatectl | grep "Time zone")"
    keyboard_status="Keyboard: $(grep XKBLAYOUT /etc/default/keyboard)"
    log "INFO" "System Status:\n$locale_status\n$timezone_status\n$keyboard_status"

    # Configure Raspberry Pi Interfaces
    log "INFO" "Configuring Raspberry Pi interfaces..."
    
    # Enable Interfaces
    log "INFO" "Enabling required interfaces..."
    
    # VNC
    sudo raspi-config nonint do_vnc 0
    
    # SPI
    sudo raspi-config nonint do_spi 0
    
    # I2C
    sudo raspi-config nonint do_i2c 0
    
    # Serial Port (Enable hardware, disable console)
    sudo raspi-config nonint do_serial 1
    sudo raspi-config nonint do_serial_hw 0
    
    # Remote GPIO
    sudo raspi-config nonint do_rgpio 0
    
    # Disable Interfaces
    log "INFO" "Disabling unused interfaces..."
    
    # 1-Wire
    sudo raspi-config nonint do_onewire 1
    
    # Apply changes
    log "INFO" "Applying interface configurations..."
    
    # Backup existing config.txt
    if [ -f "$CONFIG_FILE" ]; then
        cp "$CONFIG_FILE" "${CONFIG_FILE}.backup"
    fi
    
    # Update config.txt to ensure settings are applied
    {
        echo "# Interface configurations"
        echo "enable_uart=1"
        echo "dtparam=spi=on"
        echo "dtparam=i2c_arm=on"
        echo "dtparam=i2c=on"
        echo "gpio=on"
    } | sudo tee -a "$CONFIG_FILE"

    # Backup existing modules
    if [ -f "$MODULES_FILE" ]; then
        cp "$MODULES_FILE" "${MODULES_FILE}.backup"
    fi
    
    # Ensure modules are loaded
    {
        echo "# Interface-related modules"
        echo "i2c-dev"
        echo "spi-bcm2835"
    } | sudo tee -a "$MODULES_FILE"

    # Create base directories first
    log "INFO" "Creating base directories..."
    mkdir -p "$BASE_DIR"
    mkdir -p "$BASE_DIR/CC/application" "$BASE_DIR/CC/diagnose/app" \
             "$BASE_DIR/CC/elevator/app" "$BASE_DIR/CC/databases" \
             "$BASE_DIR/CC/logs"

    # Download and extract images
    log "INFO" "Downloading and extracting images..."
    if wget -O "$BASE_DIR/images.zip" "$IMAGES_ZIP"; then
        unzip -o "$BASE_DIR/images.zip" -d "$BASE_DIR"
        rm "$BASE_DIR/images.zip"  # Clean up zip file after extraction
    else
        log "WARN" "Failed to download images.zip, creating a blank splash image"
        convert -size 800x480 xc:black "$BASE_DIR/splash.png" || {
            log "WARN" "Could not create splash image, skipping"
            touch "$BASE_DIR/splash.png"
        }
    fi

    # VNC Server setup (works in both SSH and local)
    log "INFO" "Configuring VNC server..."
    
    # Install additional required packages for VNC
    log "INFO" "Installing VNC dependencies..."
    sudo apt-get install -y lightdm xserver-xorg-core xserver-xorg-video-fbdev realvnc-vnc-server expect

    # Configure LightDM as display manager
    sudo systemctl enable lightdm.service
    
    # Create necessary VNC directories
    log "INFO" "Creating VNC configuration directories..."
    sudo mkdir -p /etc/vnc/config.d
    sudo mkdir -p /root/.vnc/config.d

    # Configure VNC virtual desktop
    log "INFO" "Configuring VNC virtual desktop..."
    cat <<EOF | sudo tee /etc/vnc/config.d/common.custom
## Custom configurations
Geometry=800x480
FrameRate=30
SecurityTypes=VncAuth,TLSVnc
EOF

    # Configure VNC authentication
    log "INFO" "Setting up VNC password..."
    if ! [ -f "/root/.vnc/passwd" ]; then
        # Set VNC password using RealVNC's preferred method
        log "INFO" "Setting VNC password..."
        echo "heethings" | sudo vncpasswd -service -print | sudo tee /root/.vnc/config.d/vncserver-x11-auth >/dev/null
        sudo chmod 600 /root/.vnc/config.d/vncserver-x11-auth
    fi

    # Configure VNC server settings
    log "INFO" "Configuring VNC server settings..."
    cat <<EOF | sudo tee /root/.vnc/config.d/vncserver-x11
## VNC Server Configuration
Geometry=800x480
Authentication=VncAuth
Password=\$(cat /root/.vnc/config.d/vncserver-x11-auth)
EOF
    sudo chmod 600 /root/.vnc/config.d/vncserver-x11
    
    # Enable and start VNC server
    sudo systemctl enable vncserver-x11-serviced.service
    if ! systemctl is-active vncserver-x11-serviced.service >/dev/null 2>&1; then
        log "INFO" "Starting VNC server..."
        sudo systemctl start vncserver-x11-serviced.service
    fi

    # Create xstartup file for VNC
    mkdir -p ~/.vnc
    cat <<EOF > ~/.vnc/xstartup
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XKL_XMODMAP_DISABLE=1
export XDG_RUNTIME_DIR="/run/user/\$(id -u)"

# Start window manager
startlxde-pi &
EOF
    chmod +x ~/.vnc/xstartup

    # Ensure correct permissions
    sudo chown -R pi:pi ~/.vnc

    # Set default display resolution for touchscreen
    if [ ! -f ~/.config/autostart/resolution.desktop ]; then
        mkdir -p ~/.config/autostart
        cat <<EOF > ~/.config/autostart/resolution.desktop
[Desktop Entry]
Type=Application
Name=SetResolution
Exec=xrandr --output default --mode 800x480
EOF
        chmod +x ~/.config/autostart/resolution.desktop
    fi

    # Set Wallpaper and Splash Image
    log "INFO" "Setting up wallpaper and splash image..."
    if [ -f "$BASE_DIR/splash.png" ]; then
        sudo cp "$BASE_DIR/splash.png" /usr/share/plymouth/themes/pix/splash.png
        if ! is_ssh_session && [ -n "$DISPLAY" ]; then
            pcmanfm --set-wallpaper="$BASE_DIR/splash.png"
        fi
    else
        log "WARN" "Splash image not found, skipping wallpaper setup"
    fi

    # Backup existing files if any
    if [ -d "$BASE_DIR" ]; then
        log "INFO" "Creating backup of existing installation"
        mkdir -p "$BACKUP_DIR"
        cp -r "$BASE_DIR" "$BACKUP_DIR/backup_$(date +%Y%m%d_%H%M%S)"
    fi

    # 1. Install Required Packages
    log "INFO" "Installing required packages..."
    if ! sudo apt-get update; then
        log "ERROR" "Failed to update package list"
        exit 1
    fi
    
    if ! sudo apt-get -y install libsqlite3-0 libsqlite3-dev i2c-tools unclutter jq; then
        log "ERROR" "Failed to install required packages"
        exit 1
    fi

    # Create temporary systemd service for auto-restart
    SCRIPT_PATH=$(readlink -f "$0")
    cat <<EOF | sudo tee /etc/systemd/system/heethings-setup.service
[Unit]
Description=Heethings Setup Continuation
After=network.target

[Service]
Type=oneshot
ExecStart=$SCRIPT_PATH
RemainAfterExit=no
User=pi

[Install]
WantedBy=multi-user.target
EOF

    # Enable the service for next boot
    sudo systemctl enable heethings-setup.service

    # Set next step before reboot
    echo "1" > "$STEP_FILE"
    
    log "INFO" "Initial setup complete. System will reboot to apply changes..."
    log "INFO" "Script will automatically continue after reboot"
    sudo reboot now
    ;;

  1)
    log "INFO" "Starting post-reboot configuration..."
    
    # Wait for network before proceeding
    wait_for_network || {
        log "ERROR" "Network not available, cannot proceed"
        exit 1
    }
    
    # Verify system is ready
    log "INFO" "Verifying system readiness..."
    systemctl is-system-running --wait

    # Verify hardware configurations
    log "INFO" "Verifying hardware configurations..."
    interfaces_status=""
    interfaces_status+="VNC: $(systemctl is-active vncserver-x11-serviced.service)\n"
    interfaces_status+="SPI: $([ -e /dev/spidev0.0 ] && echo 'enabled' || echo 'disabled')\n"
    interfaces_status+="I2C: $([ -e /dev/i2c-1 ] && echo 'enabled' || echo 'disabled')\n"
    interfaces_status+="Serial Hardware: $([ -e /dev/serial0 ] && echo 'enabled' || echo 'disabled')\n"
    interfaces_status+="RTC: $([ -e /dev/rtc0 ] && echo 'enabled' || echo 'disabled')\n"
    log "INFO" "Interface Status:\n$interfaces_status"

    # Set hardware clock
    if [ -e /dev/rtc0 ]; then
        log "INFO" "Setting hardware clock..."
        sudo hwclock -w
    else
        log "WARN" "RTC device not found, skipping hardware clock setup"
    fi

    # Remove step file as we don't need it anymore
    rm -f "$STEP_FILE"

    # Continue with the rest of the installation
    log "INFO" "Proceeding with application installation..."

    # 4. Prepare Folders
    log "INFO" "Creating required directories..."
    mkdir -p "$BASE_DIR/CC/application" "$BASE_DIR/CC/diagnose/app" \
             "$BASE_DIR/CC/elevator/app" "$BASE_DIR/CC/databases" \
             "$BASE_DIR/CC/logs"

    # 5. Fetch Latest Versions and Download Files
    log "INFO" "Fetching app versions..."
    if ! response=$(curl -s "$API_URL"); then
        log "ERROR" "Failed to fetch app versions from API"
        exit 1
    fi

    app_url=$(echo "$response" | jq -r .data.app.url)
    elevator_url=$(echo "$response" | jq -r .data.elevator.url)
    diagnose_url=$(echo "$response" | jq -r .data.diagnose.url)

    # Download zips with retry and verification
    log "INFO" "Downloading application files..."
    download_with_retry "$app_url" "$BASE_DIR/CC/application/app.zip"
    download_with_retry "$elevator_url" "$BASE_DIR/CC/elevator/app/elevator.zip"
    download_with_retry "$diagnose_url" "$BASE_DIR/CC/diagnose/app/diagnose.zip"
    download_with_retry "$IMAGES_ZIP" "$BASE_DIR/images.zip"
    download_with_retry "$SENSOR_ZIP" "$BASE_DIR/sensor.zip"
    download_with_retry "$SCRIPTS_ZIP" "$BASE_DIR/scripts.zip"

    # Verify all zip files
    log "INFO" "Verifying downloaded files..."
    for zip_file in "$BASE_DIR"/**/*.zip "$BASE_DIR"/*.zip; do
        if ! verify_zip "$zip_file"; then
            log "ERROR" "Verification failed for $zip_file"
            exit 1
        fi
    done

    # 6. Extract Files
    log "INFO" "Extracting files..."
    unzip -o "$BASE_DIR/CC/application/app.zip" -d "$BASE_DIR/CC/application"
    unzip -o "$BASE_DIR/CC/elevator/app/elevator.zip" -d "$BASE_DIR/CC/elevator/app"
    unzip -o "$BASE_DIR/CC/diagnose/app/diagnose.zip" -d "$BASE_DIR/CC/diagnose/app"
    unzip -o "$BASE_DIR/images.zip" -d "$BASE_DIR"
    unzip -o "$BASE_DIR/sensor.zip" -d "$BASE_DIR"
    unzip -o "$BASE_DIR/scripts.zip" -d "$BASE_DIR"

    # 7. Update Permissions for Scripts
    log "INFO" "Updating script permissions..."
    chmod +x "$BASE_DIR"/*.sh

    # 8. Install Sensor Script
    log "INFO" "Running sensor installation script..."
    cd "$BASE_DIR" && ./install-sensor-script.sh

    # 9. Configure Auto-Start
    log "INFO" "Configuring auto-start for the main app..."
    AUTOSTART_FILE="/etc/systemd/system/cc.service"
    cat <<EOF | sudo tee "$AUTOSTART_FILE"
[Unit]
Description=Central Heating Control
After=network.target

[Service]
Type=simple
ExecStart=$BASE_DIR/CC/application/central_heating_control
Restart=always
User=pi

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl enable cc.service

    # 10. Set Wallpaper and Splash Image (if not in SSH)
    log "INFO" "Setting up wallpaper and splash image..."
    sudo cp "$BASE_DIR/splash.png" /usr/share/plymouth/themes/pix/splash.png

    # Check if DISPLAY is set and desktop environment is running
    if [ -n "$DISPLAY" ] && command -v pcmanfm >/dev/null 2>&1; then
        # Wait for desktop environment to be ready (max 30 seconds)
        counter=0
        while [ $counter -lt 30 ]; do
            if pgrep lxsession >/dev/null 2>&1; then
                log "INFO" "Desktop environment detected, setting wallpaper"
                DISPLAY=:0 pcmanfm --set-wallpaper="$BASE_DIR/splash.png"
                break
            fi
            log "INFO" "Waiting for desktop environment... ($counter/30)"
            sleep 1
            ((counter++))
        done
        
        if [ $counter -eq 30 ]; then
            log "WARN" "Desktop environment not detected after 30 seconds, skipping wallpaper setup"
        fi
    else
        log "WARN" "Desktop environment not available, skipping wallpaper setup"
    fi

    # 11. Hide Mouse Cursor (if not in SSH)
    log "INFO" "Setting up mouse cursor..."
    if [ -n "$DISPLAY" ]; then
        unclutter -idle 0 &
        log "INFO" "Mouse cursor hidden"
    else
        log "WARN" "Display not available, skipping mouse cursor setup"
    fi

    # 12. Download Wallpaper Images
    log "INFO" "Downloading wallpaper images..."
    mkdir -p "$PICTURES_DIR"

    for i in $(seq -w 1 19); do
        wget -O "$PICTURES_DIR/wp${i}.jpg" "https://static.api2.run/pi/wallpaper/wp${i}.jpg"
    done

    echo "Wallpaper images downloaded to $PICTURES_DIR."

    # Cleanup downloaded zip files
    log "INFO" "Cleaning up downloaded files..."
    find "$BASE_DIR" -name "*.zip" -type f -delete

    # Verify critical components
    log "INFO" "Verifying installation..."
    if [ ! -f "$BASE_DIR/CC/application/central_heating_control" ]; then
        log "ERROR" "Main application binary not found"
        exit 1
    fi

    # Cleanup: disable and remove the temporary service
    log "INFO" "Cleaning up installation service..."
    if [ -f "/etc/systemd/system/heethings-setup.service" ]; then
        sudo systemctl stop heethings-setup.service
        sudo systemctl disable heethings-setup.service
        sudo rm /etc/systemd/system/heethings-setup.service
        sudo systemctl daemon-reload
    fi

    # Create completion marker
    echo "Installation completed at $(date)" | sudo tee /boot/firmware/heethings-install-complete.txt

    # Install zenity if not present
    if ! command -v zenity >/dev/null 2>&1; then
        sudo apt-get install -y zenity
    fi

    # Show completion dialog on display
    if [ -n "$DISPLAY" ]; then
        # Create desktop notification
        DISPLAY=:0 notify-send -u critical "Heethings Installation" "Installation completed successfully!"
        
        # Show completion dialog
        DISPLAY=:0 zenity --info \
            --title="Heethings Installation Complete" \
            --width=400 \
            --text="Installation has been completed successfully!\n\nWould you like to reboot now?" \
            --ok-label="Reboot" \
            --cancel-label="Later"
        
        if [ $? -eq 0 ]; then
            # User clicked Reboot
            log "INFO" "User requested reboot through GUI"
            sudo reboot now
        else
            # User clicked Later
            log "INFO" "User chose to reboot later through GUI"
            DISPLAY=:0 zenity --info \
                --title="Reboot Required" \
                --width=400 \
                --text="Please remember to reboot your system when convenient.\n\nThe installation is complete."
        fi
    else
        # Fallback to command line prompt if no display
        read -p "Would you like to reboot now to complete the installation? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log "INFO" "Final reboot initiated..."
            sudo reboot now
        else
            log "INFO" "Remember to reboot your system when convenient"
        fi
    fi

    # Final verification
    log "INFO" "Running final verification..."
    if systemctl is-enabled cc.service >/dev/null 2>&1; then
        log "INFO" "Auto-start service successfully configured"
    else
        log "WARN" "Auto-start service might not be properly configured"
    fi

    # Clear completion notification
    log "INFO" "================================================================="
    log "INFO" "                 INSTALLATION COMPLETED SUCCESSFULLY              "
    log "INFO" "================================================================="
    log "INFO" "Main service (cc.service) is installed and configured"
    log "INFO" "VNC server is configured and running"
    log "INFO" "All configurations are applied"
    log "INFO" "You can check the full log at: $LOG_FILE"
    log "INFO" "================================================================="
    ;;
esac
