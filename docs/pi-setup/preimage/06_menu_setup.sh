#!/bin/bash

echo "Setting up Heethings menu item..."

# First remove any existing menu items
rm -f /usr/share/applications/heethings-installer.desktop
rm -f /etc/xdg/autostart/heethings.desktop
rm -f /home/pi/.local/share/applications/heethings-installer.desktop
rm -f /home/pi/.config/autostart/heethings.desktop

# Create applications directory if it doesn't exist
mkdir -p /usr/share/applications

# Ensure all scripts are executable
chmod +x /home/pi/pi-setup/postimage/install_heethings.sh
chmod +x /home/pi/pi-setup/preimage/*.sh
chmod +x /home/pi/pi-setup/postimage/*.sh 2>/dev/null || true

# Create desktop entry for Heethings installer
cat > /usr/share/applications/heethings-installer.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Install Heethings
Comment=Install Heethings Central Heating Control
Exec=lxterminal -t "Heethings Installation" -e "cd /home/pi/pi-setup/postimage && sudo ./install_heethings.sh"
Icon=/home/pi/Heethings/app_icon.png
Terminal=false
Categories=System;Settings;
EOF

# Make it executable
chmod +x /usr/share/applications/heethings-installer.desktop

# Skip menu refresh during SSH installation
# Menu will be refreshed automatically after reboot
echo "Menu entry created. Menu will be refreshed after reboot."

echo "Menu setup complete."
