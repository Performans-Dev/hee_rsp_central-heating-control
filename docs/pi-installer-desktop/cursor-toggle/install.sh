#!/bin/bash

# Make sure we're in the right directory
cd "$(dirname "$0")"

# Clean up previous installation
rm -rf /usr/share/icons/InvisibleCursor
rm -f /home/pi/toggle-cursor.sh
rm -f /usr/share/applications/toggle-cursor.desktop
rm -f /etc/polkit-1/localauthority/50-local.d/99-cursor-toggle.pkla

# Install required packages
apt-get update
apt-get install -y zenity policykit-1 x11-xserver-utils

# Install invisible cursor theme
echo "Installing invisible cursor theme..."
bash setup-cursor.sh

# Install toggle functionality
echo "Installing cursor toggle..."
bash install-cursor-toggle.sh

# Create polkit directory if it doesn't exist
mkdir -p /etc/polkit-1/localauthority/50-local.d/

# Install policy file
cp 99-cursor-toggle.pkla /etc/polkit-1/localauthority/50-local.d/
chmod 644 /etc/polkit-1/localauthority/50-local.d/99-cursor-toggle.pkla

echo "Installation complete!"
echo "You can now find 'Toggle Cursor' in the Preferences menu."
echo "Note: You need to restart X session after toggling the cursor."
