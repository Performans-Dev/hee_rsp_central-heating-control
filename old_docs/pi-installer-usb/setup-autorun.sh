#!/bin/bash

# This script sets up autorun for USB drives on Raspberry Pi
# Run this once on the Pi to enable autorun functionality

echo "Setting up Heethings USB autorun..."

# Install required packages
echo "Installing required packages..."
sudo apt-get update
sudo apt-get install -y zenity libnotify-bin pmount

# Create required directories
echo "Creating required directories..."
sudo mkdir -p /etc/udev/rules.d/
sudo mkdir -p /media/HEETHINGS

# Create udev rule for automounting and autorun
echo "Setting up USB automount rules..."
sudo tee /etc/udev/rules.d/85-heethings-autorun.rules > /dev/null << 'EOL'
ACTION=="add", SUBSYSTEM=="block", ENV{ID_FS_USAGE}=="filesystem", ENV{ID_FS_LABEL}=="HEETHINGS", \
    RUN+="/bin/mkdir -p /media/HEETHINGS", \
    RUN+="/usr/bin/pmount --umask=000 /dev/%k HEETHINGS", \
    RUN+="/bin/su pi -c '/bin/bash /media/HEETHINGS/autorun.sh'"
EOL

# Create systemd service for GUI notification
echo "Creating notification service..."
sudo tee /etc/systemd/system/heethings-notify.service > /dev/null << 'EOL'
[Unit]
Description=Heethings USB Notification
After=graphical-session.target

[Service]
Type=simple
User=pi
Environment=DISPLAY=:0
ExecStart=/usr/bin/notify-send "Heethings Installer" "Installation wizard starting..."

[Install]
WantedBy=graphical-session.target
EOL

# Add pi user to plugdev group (needed for USB access)
echo "Configuring user permissions..."
sudo usermod -a -G plugdev pi

# Reload udev rules
echo "Applying new rules..."
sudo udevadm control --reload-rules
sudo systemctl daemon-reload

echo "Setup complete! Please reboot your Raspberry Pi for changes to take effect."
echo "After reboot, inserting a USB drive labeled 'HEETHINGS' will automatically start the installer."

# Offer to reboot
read -p "Would you like to reboot now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo reboot
fi
