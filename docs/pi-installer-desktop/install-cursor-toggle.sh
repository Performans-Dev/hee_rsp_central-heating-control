#!/bin/bash

# Install required packages
apt-get update
apt-get install -y zenity policykit-1

# Copy toggle script
cp toggle-cursor.sh /home/pi/
chmod +x /home/pi/toggle-cursor.sh
chown pi:pi /home/pi/toggle-cursor.sh

# Copy desktop entry
cp toggle-cursor.desktop /usr/share/applications/
chmod 644 /usr/share/applications/toggle-cursor.desktop

# Install policy file
cp 99-cursor-toggle.pkla /etc/polkit-1/localauthority/50-local.d/
chmod 644 /etc/polkit-1/localauthority/50-local.d/99-cursor-toggle.pkla

echo "Cursor toggle installed. You can find 'Toggle Cursor' in the Preferences menu."
