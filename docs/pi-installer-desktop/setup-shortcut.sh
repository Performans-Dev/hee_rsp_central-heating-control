#!/bin/bash

# Function to show message (uses zenity if available, falls back to echo)
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

# Install required packages
apt-get update
apt-get install -y zenity lxterminal jq pcmanfm libsqlite3-0 libsqlite3-dev i2c-tools zip unzip

# Create the desktop entry
cat > /usr/share/applications/heethings-installer.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Install Heethings
Comment=Install or update Heethings applications
Exec=lxterminal -e "sudo /home/pi/install.sh"
Icon=system-software-install
Terminal=false
Categories=System;
EOF

# Make desktop entry executable
chmod +x /usr/share/applications/heethings-installer.desktop

# Create the actual install script
cat > /home/pi/install.sh << 'EOF'
#!/bin/bash

# Prevent script from running if not as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (sudo)"
    exit 1
fi

BASE_DIR="/home/pi/Heethings"
PICTURES_DIR="/home/pi/Pictures"
IMAGES_ZIP="https://releases.api2.run/heethings/cc/images.zip"
SENSOR_ZIP="https://releases.api2.run/heethings/cc/sensor.zip"
SCRIPTS_ZIP="https://releases.api2.run/heethings/cc/scripts.zip"
API_URL="https://chc-api.globeapp.dev/api/v1/settings/app/version"

# Function to backup existing installation
backup_existing() {
    if [ -d "$BASE_DIR" ]; then
        echo "Backing up existing installation..."
        BACKUP_NAME="Heethings_backup_$(date +%Y%m%d_%H%M%S).zip"
        cd /home/pi
        zip -r "$BACKUP_NAME" Heethings/
        echo "Existing installation backed up to: /home/pi/$BACKUP_NAME"
    fi
}

# Function to clean up old backups
cleanup_old_backups() {
    echo "Cleaning up old backups..."
    # Keep only the 3 most recent backups
    cd /home/pi
    ls -t Heethings_backup_*.zip 2>/dev/null | tail -n +4 | xargs -r rm -f
}

echo "Running Heethings installer..."

# Install required packages
echo "Installing required packages..."
apt-get update
apt-get install -y libsqlite3-0 libsqlite3-dev i2c-tools jq zip unzip

# 1. Enable interfaces (only if not already enabled)
echo "Setting up interfaces..."
raspi-config nonint get_spi || raspi-config nonint do_spi 0
raspi-config nonint get_i2c || raspi-config nonint do_i2c 0
raspi-config nonint get_serial || raspi-config nonint do_serial 1

# 2. Set up RTC (only if not already set)
echo "Setting up RTC..."
if ! grep -q "dtoverlay=i2c-rtc,ds3231" /boot/firmware/config.txt; then
    echo "dtoverlay=i2c-rtc,ds3231" >> /boot/firmware/config.txt
fi

# Backup existing installation
backup_existing

# Remove existing installation to ensure clean state
rm -rf "$BASE_DIR"

# 3. Create directories
echo "Creating directories..."
mkdir -p "$BASE_DIR/CC/application"
mkdir -p "$BASE_DIR/CC/elevator/app"
mkdir -p "$BASE_DIR/CC/diagnose/app"
mkdir -p "$PICTURES_DIR"

# 4. Download Flutter apps
echo "Downloading Flutter applications..."
response=$(curl -s "$API_URL")
app_url=$(echo "$response" | jq -r .data.app.url)
elevator_url=$(echo "$response" | jq -r .data.elevator.url)
diagnose_url=$(echo "$response" | jq -r .data.diagnose.url)

wget -q --show-progress "$app_url" -O "$BASE_DIR/CC/application/app.zip"
wget -q --show-progress "$elevator_url" -O "$BASE_DIR/CC/elevator/app/elevator.zip"
wget -q --show-progress "$diagnose_url" -O "$BASE_DIR/CC/diagnose/app/diagnose.zip"

# 5. Download support files
echo "Downloading support files..."
wget -q --show-progress "$IMAGES_ZIP" -O "/tmp/images.zip"
wget -q --show-progress "$SENSOR_ZIP" -O "/tmp/sensor.zip"
wget -q --show-progress "$SCRIPTS_ZIP" -O "/tmp/scripts.zip"

# 6. Extract Flutter apps
echo "Extracting Flutter applications..."
unzip -o "$BASE_DIR/CC/application/app.zip" -d "$BASE_DIR/CC/application"
unzip -o "$BASE_DIR/CC/elevator/app/elevator.zip" -d "$BASE_DIR/CC/elevator/app"
unzip -o "$BASE_DIR/CC/diagnose/app/diagnose.zip" -d "$BASE_DIR/CC/diagnose/app"

# 7. Extract support files
echo "Extracting support files..."
unzip -o "/tmp/images.zip" -d "$BASE_DIR"
unzip -o "/tmp/sensor.zip" -d "$BASE_DIR"
unzip -o "/tmp/scripts.zip" -d "$BASE_DIR"

# 8. Set up wallpaper and splash
echo "Setting up wallpaper and splash..."
cp "$BASE_DIR/splash.png" /usr/share/plymouth/themes/pix/splash.png

# Set wallpaper using LXDE config
mkdir -p /home/pi/.config/pcmanfm/LXDE-pi
cat > /home/pi/.config/pcmanfm/LXDE-pi/desktop-items-0.conf << 'INNEREOF'
[*]
wallpaper_mode=crop
wallpaper_common=1
wallpaper=/home/pi/Heethings/splash.png
desktop_bg=#000000
desktop_fg=#ffffff
desktop_shadow=#000000
desktop_font=PibotoLt 12
show_wm_menu=0
sort=mtime;ascending;
show_documents=0
show_trash=0
show_mounts=0
INNEREOF

chown -R pi:pi /home/pi/.config/pcmanfm

# 9. Download screensaver images
echo "Downloading screensaver images..."
for i in {1..19}; do
    wget -q --show-progress "https://releases.api2.run/heethings/cc/images/$i.jpg" -O "$PICTURES_DIR/$i.jpg"
done

# 10. Run sensor installation
echo "Installing sensor..."
chmod +x "$BASE_DIR/install-sensor-script.sh"
"$BASE_DIR/install-sensor-script.sh"

# 11. Create autostart for main app
echo "Setting up autostart..."
mkdir -p /home/pi/.config/autostart
cat > /home/pi/.config/autostart/heethings.desktop << 'INNEREOF'
[Desktop Entry]
Type=Application
Name=Heethings
Exec=/home/pi/Heethings/CC/application/central_heating_control
Icon=/home/pi/Heethings/app_icon.png
Terminal=false
X-GNOME-Autostart-enabled=true
INNEREOF

chmod +x /home/pi/.config/autostart/heethings.desktop
chown pi:pi /home/pi/.config/autostart/heethings.desktop

# Also create system-wide autostart (as backup)
cat > /etc/xdg/autostart/heethings.desktop << 'INNEREOF'
[Desktop Entry]
Type=Application
Name=Heethings
Exec=/home/pi/Heethings/CC/application/central_heating_control
Icon=/home/pi/Heethings/app_icon.png
Terminal=false
X-GNOME-Autostart-enabled=true
INNEREOF

chmod +x /etc/xdg/autostart/heethings.desktop

# 12. Create application menu shortcut
cat > /usr/share/applications/heethings.desktop << 'INNEREOF'
[Desktop Entry]
Type=Application
Name=Heethings
Exec=/home/pi/Heethings/CC/application/central_heating_control
Icon=/home/pi/Heethings/app_icon.png
Terminal=false
Categories=Utility;
INNEREOF

chmod +x /usr/share/applications/heethings.desktop

# 13. Set permissions
chown -R pi:pi "$BASE_DIR"
chown -R pi:pi "$PICTURES_DIR"
chmod +x "$BASE_DIR/CC/application/central_heating_control"

# Clean up
rm -f /tmp/*.zip

# Clean up old backups
cleanup_old_backups

echo "Installation complete! System will reboot to apply changes."
echo "Press Enter to reboot..."
read

reboot
EOF

# Make install script executable and set ownership
chmod +x /home/pi/install.sh
chown pi:pi /home/pi/install.sh

# Update desktop database
update-desktop-database

# Show completion message
show_message "Installation shortcut has been created in the applications menu.\nClick it anytime to install Heethings."
