#!/bin/bash

# =============================================================================
# Heethings Installation Setup Script
# =============================================================================
# This script creates a desktop shortcut and installation script for the
# Heethings application on Raspberry Pi running Debian/Raspbian.
#
# The script performs the following main tasks:
# 1. Creates a desktop shortcut for the installer
# 2. Generates the main installation script
# 3. Sets up proper permissions and configurations
#
# Requirements:
# - Raspberry Pi running Debian/Raspbian
# - Root privileges (sudo)
# - Working desktop environment (LXDE)
# =============================================================================

# Prevent script from running if not as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (sudo)"
    exit 1
fi

# Function to show message using zenity if available, falls back to echo
show_message() {
    if [ -n "$DISPLAY" ] && command -v zenity >/dev/null 2>&1; then
        zenity --info \
            --title="Heethings Installer" \
            --text="$1" \
            --width=400
    else
        echo -e "[INFO] $1"
    fi
}

# Create desktop shortcut for the installer
mkdir -p /usr/share/applications
cat > /usr/share/applications/heethings-installer.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Install Heethings
Comment=Install Heethings Central Heating Control
Icon=/usr/share/pixmaps/debian-logo.png
Exec=sudo /home/pi/install.sh
Terminal=true
Categories=System;
EOF

chmod +x /usr/share/applications/heethings-installer.desktop

# Create the actual install script
cat > /home/pi/install.sh << 'INSTALLEOF'
#!/bin/bash

# =============================================================================
# Heethings Main Installation Script
# =============================================================================
# This script performs the complete installation of Heethings application
# including all dependencies, configurations, and system settings.
#
# The installation process includes:
# - Setting up system locale
# - Installing required packages
# - Configuring system interfaces (I2C, SPI)
# - Setting up RTC (Real-Time Clock)
# - Installing Flutter applications
# - Setting up autostart
# =============================================================================

# Prevent script from running if not as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (sudo)"
    exit 1
fi

# Set system-wide locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

BASE_DIR="/home/pi/Heethings"
PICTURES_DIR="/home/pi/Pictures"
IMAGES_ZIP="https://releases.api2.run/heethings/cc/images.zip"
SENSOR_ZIP="https://releases.api2.run/heethings/cc/sensor.zip"
SCRIPTS_ZIP="https://releases.api2.run/heethings/cc/scripts.zip"
API_URL="https://chc-api.globeapp.dev/api/v1/settings/app/version"

# Function to show message
show_message() {
    if [ -n "$DISPLAY" ] && command -v zenity >/dev/null 2>&1; then
        zenity --info \
            --title="Heethings Installer" \
            --text="$1" \
            --width=400
    else
        echo -e "[INFO] $1"
    fi
}

# Function to show progress
show_progress() {
    echo "=== $1 ==="
}

# Function to backup existing installation
backup_existing() {
    if [ -d "$BASE_DIR" ]; then
        show_progress "Backing up existing installation"
        BACKUP_NAME="Heethings_backup_$(date +%Y%m%d_%H%M%S).zip"
        cd /home/pi
        zip -r "$BACKUP_NAME" Heethings/
        echo "Existing installation backed up to: /home/pi/$BACKUP_NAME"
    fi
}

# Function to clean up old backups
cleanup_old_backups() {
    show_progress "Cleaning up old backups"
    cd /home/pi
    ls -t Heethings_backup_*.zip 2>/dev/null | tail -n +4 | xargs -r rm -f
}

# Function to clean up existing service and files
cleanup_existing() {
    show_progress "Cleaning up existing installation"
    
    # Stop and disable service if it exists
    if systemctl is-active --quiet heethings-sensor.service; then
        show_progress "Stopping sensor service"
        systemctl stop heethings-sensor.service
        systemctl disable heethings-sensor.service
    fi
    
    # Remove service file
    if [ -f "/etc/systemd/system/heethings-sensor.service" ]; then
        rm -f /etc/systemd/system/heethings-sensor.service
        systemctl daemon-reload
    fi
    
    # Clean up virtual environment with proper permissions
    if [ -d "$BASE_DIR/CC/sensor/sensor_env" ]; then
        show_progress "Removing old virtual environment"
        chmod -R 777 "$BASE_DIR/CC/sensor/sensor_env"
        rm -rf "$BASE_DIR/CC/sensor/sensor_env"
    fi
}

show_progress "Running Heethings installer"

# Install required packages
show_progress "Installing required packages"
apt-get update
apt-get install -y libsqlite3-0 libsqlite3-dev i2c-tools jq zip unzip python3-pip python3-flask python3-spidev

# Enable interfaces
show_progress "Setting up interfaces"
# Check if raspi-config exists and is executable
if [ -x "$(command -v raspi-config)" ]; then
    # Try raspi-config first, but don't fail if it doesn't work
    raspi-config nonint get_spi || true
    raspi-config nonint do_spi 0 || true
    raspi-config nonint get_i2c || true
    raspi-config nonint do_i2c 0 || true
fi

# Always do manual configuration to ensure interfaces are enabled
show_progress "Configuring interfaces manually"

# Enable SPI
if ! grep -q "^dtparam=spi=on" /boot/firmware/config.txt; then
    echo "dtparam=spi=on" >> /boot/firmware/config.txt
fi

# Enable I2C
if ! grep -q "^dtparam=i2c_arm=on" /boot/firmware/config.txt; then
    echo "dtparam=i2c_arm=on" >> /boot/firmware/config.txt
fi

# Enable SPI overlay
if ! grep -q "^dtoverlay=spi0-1cs" /boot/firmware/config.txt; then
    echo "dtoverlay=spi0-1cs" >> /boot/firmware/config.txt
fi

# Load modules
modprobe spi-bcm2835 || true
modprobe i2c-dev || true

# Set up RTC
show_progress "Setting up RTC"
if ! grep -q "dtoverlay=i2c-rtc,ds3231" /boot/firmware/config.txt; then
    echo "dtoverlay=i2c-rtc,ds3231" >> /boot/firmware/config.txt
fi

# Backup, cleanup, and remove existing installation
cleanup_existing
backup_existing
cleanup_old_backups

# Remove existing installation
rm -rf "$BASE_DIR"

# Create directories
show_progress "Creating directories"
mkdir -p "$BASE_DIR/CC/application"
mkdir -p "$BASE_DIR/CC/elevator/app"
mkdir -p "$BASE_DIR/CC/diagnose/app"
mkdir -p "$BASE_DIR/CC/sensor/script"
mkdir -p "$PICTURES_DIR"

# Set proper permissions
chown -R pi:pi "$BASE_DIR"
chmod -R 755 "$BASE_DIR"

# Download Flutter apps
show_progress "Downloading Flutter applications"
response=$(curl -s "$API_URL")
app_url=$(echo "$response" | jq -r .data.app.url)
elevator_url=$(echo "$response" | jq -r .data.elevator.url)
diagnose_url=$(echo "$response" | jq -r .data.diagnose.url)

wget -q --show-progress "$app_url" -O "$BASE_DIR/CC/application/app.zip"
wget -q --show-progress "$elevator_url" -O "$BASE_DIR/CC/elevator/app/elevator.zip"
wget -q --show-progress "$diagnose_url" -O "$BASE_DIR/CC/diagnose/app/diagnose.zip"

# Download sensor files
show_progress "Downloading sensor files"
if ! wget -q --show-progress "$SENSOR_ZIP" -O "$BASE_DIR/CC/sensor.zip"; then
    echo "ERROR: Failed to download sensor.zip"
    exit 1
fi

# Download support files
show_progress "Downloading support files"
if ! wget -q --show-progress "$IMAGES_ZIP" -O "/tmp/images.zip"; then
    echo "ERROR: Failed to download images.zip"
    exit 1
fi

if ! wget -q --show-progress "$SCRIPTS_ZIP" -O "/tmp/scripts.zip"; then
    echo "ERROR: Failed to download scripts.zip"
    exit 1
fi

# Extract files
show_progress "Extracting files"
unzip -o "$BASE_DIR/CC/sensor.zip" -d "$BASE_DIR/CC"
unzip -o "$BASE_DIR/CC/application/app.zip" -d "$BASE_DIR/CC/application"
unzip -o "$BASE_DIR/CC/elevator/app/elevator.zip" -d "$BASE_DIR/CC/elevator/app"
unzip -o "$BASE_DIR/CC/diagnose/app/diagnose.zip" -d "$BASE_DIR/CC/diagnose/app"
unzip -o "/tmp/images.zip" -d "$BASE_DIR"
unzip -o "/tmp/scripts.zip" -d "$BASE_DIR"

# Download screensaver images
show_progress "Setting up screensaver"
rm -f "$PICTURES_DIR"/wp*.jpg
for i in {1..19}; do
    num=$(printf "%02d" $i)
    url="https://releases.api2.run/heethings/cc/images/wp$num.jpg"
    wget -q --show-progress "$url" -O "$PICTURES_DIR/wp$num.jpg"
done
chown -R pi:pi "$PICTURES_DIR"
chmod 644 "$PICTURES_DIR"/wp*.jpg

# Create autostart for main app
show_progress "Setting up autostart"
mkdir -p /home/pi/.config/autostart
cat > /home/pi/.config/autostart/heethings.desktop << 'AUTOEOF'
[Desktop Entry]
Type=Application
Name=Heethings
Exec=/home/pi/Heethings/CC/application/central_heating_control
Icon=/home/pi/Heethings/app_icon.png
Terminal=false
X-GNOME-Autostart-enabled=true
AUTOEOF

chmod +x /home/pi/.config/autostart/heethings.desktop
chown pi:pi /home/pi/.config/autostart/heethings.desktop

# Also create system-wide autostart (as backup)
cp /home/pi/.config/autostart/heethings.desktop /etc/xdg/autostart/

show_progress "Installation complete!"

# Ask user if they want to reboot now
if [ -n "$DISPLAY" ] && command -v zenity >/dev/null 2>&1; then
    if zenity --question \
        --title="Installation Complete" \
        --text="Installation completed successfully!\n\nThe system needs to reboot for all changes to take effect.\nWould you like to reboot now?" \
        --ok-label="Reboot Now" \
        --cancel-label="Later" \
        --width=400; then
        reboot
    else
        show_message "Please remember to reboot your system later for all changes to take effect."
    fi
else
    echo "=== Installation complete! ==="
    echo "Please reboot your system for all changes to take effect."
fi
INSTALLEOF

# Make install script executable
chmod +x /home/pi/install.sh
show_message "Installation shortcut created successfully. You can now find 'Install Heethings' in your applications menu."
