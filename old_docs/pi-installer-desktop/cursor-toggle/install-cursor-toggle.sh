#!/bin/bash

# Copy toggle script
sudo cp toggle-cursor.sh /home/pi/
sudo chmod +x /home/pi/toggle-cursor.sh
sudo chown pi:pi /home/pi/toggle-cursor.sh

# Install menu shortcut
sudo cp toggle-cursor.desktop /usr/share/applications/
sudo chmod +x /usr/share/applications/toggle-cursor.desktop

echo "Cursor toggle installed. You can find 'Toggle Cursor' in the Preferences menu."
