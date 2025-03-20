#!/bin/bash

# =============================================================================
# Phase 2.5: Final Setup and Verification
# =============================================================================

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/postimage/common.sh"

# Exit on error
set -e

BASE_DIR="/home/pi/Heethings"
CC_DIR="$BASE_DIR/CC"

log "INFO" "Performing final setup and verification..."

# Create command shortcuts
log "INFO" "Creating command shortcuts..."

# Create cc command
cat > /usr/local/bin/heethings-cc << 'EOF'
#!/bin/bash
cd /home/pi/Heethings/CC/application
./central_heating_control "$@"
EOF
chmod +x /usr/local/bin/heethings-cc

# Create cc-elevator command
cat > /usr/local/bin/heethings-cc-elevator << 'EOF'
#!/bin/bash
cd /home/pi/Heethings/CC/elevator/app
./chc_updater "$@"
EOF
chmod +x /usr/local/bin/heethings-cc-elevator

# Create cc-diagnose command
cat > /usr/local/bin/heethings-cc-diagnose << 'EOF'
#!/bin/bash
cd /home/pi/Heethings/CC/diagnose/app
./chc_diagnose "$@"
EOF
chmod +x /usr/local/bin/heethings-cc-diagnose

# Configure display and autostart settings
log "INFO" "Configuring display and autostart settings..."

# Configure screen blanking, cursor, and autostart CC app
mkdir -p /home/pi/.config/autostart
cat > /home/pi/.config/autostart/heethings.desktop << EOF
[Desktop Entry]
Type=Application
Name=Heethings CC
Exec=sudo /usr/local/bin/heethings-cc
Terminal=false
X-GNOME-Autostart-enabled=true
EOF

# Also keep the LXDE-pi autostart for screen settings
mkdir -p /home/pi/.config/lxsession/LXDE-pi
cat > /home/pi/.config/lxsession/LXDE-pi/autostart << EOF
@xset s off
@xset -dpms
@xset s noblank
@unclutter -idle 0.1 -root
EOF

# Set permissions
chmod +x /home/pi/.config/autostart/heethings.desktop
chown -R pi:pi /home/pi/.config

# Create menu entries
log "INFO" "Creating menu entries..."

# Create applications directory
mkdir -p /usr/share/applications
mkdir -p /home/pi/.local/share/applications

# Create CC menu entry
cat > /usr/share/applications/heethings-cc.desktop << EOF
[Desktop Entry]
Type=Application
Version=1.0
Name=Heethings CC
GenericName=Central Control
Comment=Heethings Central Control Application
Exec=sudo /usr/local/bin/heethings-cc
Icon=/home/pi/Heethings/app_icon.png
Terminal=false
Categories=Settings;System;
NoDisplay=false
EOF

# Create Elevator menu entry
cat > /usr/share/applications/heethings-elevator.desktop << EOF
[Desktop Entry]
Type=Application
Version=1.0
Name=Heethings Elevator
GenericName=Updater
Comment=Heethings Elevator Application
Exec=sudo /usr/local/bin/heethings-cc-elevator
Icon=/home/pi/Heethings/app_icon.png
Terminal=false
Categories=Settings;System;
NoDisplay=false
EOF

# Create Diagnose menu entry
cat > /usr/share/applications/heethings-diagnose.desktop << EOF
[Desktop Entry]
Type=Application
Version=1.0
Name=Heethings Diagnose
GenericName=Diagnostics
Comment=Heethings Diagnose Application
Exec=sudo /usr/local/bin/heethings-cc-diagnose
Icon=/home/pi/Heethings/app_icon.png
Terminal=false
Categories=Settings;System;
NoDisplay=false
EOF

# Copy to user's applications directory
cp /usr/share/applications/heethings-*.desktop /home/pi/.local/share/applications/

# Make menu entries executable and set ownership
chmod +x /usr/share/applications/heethings-*.desktop
chmod +x /home/pi/.local/share/applications/heethings-*.desktop
chown -R pi:pi /home/pi/.local/share/applications/heethings-*.desktop
chown root:root /usr/share/applications/heethings-*.desktop

# Update desktop database
update-desktop-database /usr/share/applications || true
update-desktop-database /home/pi/.local/share/applications || true

# Create menu cache directory
mkdir -p /home/pi/.cache/menus
chown -R pi:pi /home/pi/.cache/menus

# Refresh the menu
lxpanelctl restart

# Verify installation
log "INFO" "Verifying installation..."

# Check directories
log "INFO" "Checking directories..."
if [ ! -d "$CC_DIR" ]; then
    log "ERROR" "CC directory not found" && exit 1
fi

# Check executables
log "INFO" "Checking executables..."
if [ ! -x "$CC_DIR/application/central_heating_control" ]; then
    log "ERROR" "Executable not found or not executable: $CC_DIR/application/central_heating_control" && exit 1
fi

# Check sensor service
log "INFO" "Checking sensor service..."
if ! systemctl is-active --quiet sensor_server.service; then
    log "ERROR" "Sensor service is not running" && exit 1
fi

# Print installation summary
log "INFO" "Installation Summary:"
log "INFO" "-------------------"
log "INFO" "Installation Time: $(date '+%Y-%m-%d %H:%M:%S')"
log "INFO" "CC Version: $(cat $CC_DIR/versions.txt | grep 'CC App:' | cut -d' ' -f3-)"
log "INFO" "Elevator Version: $(cat $CC_DIR/versions.txt | grep 'CC-Elevator:' | cut -d' ' -f2-)"
log "INFO" "Diagnose Version: $(cat $CC_DIR/versions.txt | grep 'CC-Diagnose:' | cut -d' ' -f2-)"
log "INFO" "Sensor Service: $(systemctl is-active sensor_server.service)"
log "INFO" "-------------------"

# Ask for restart
log "INFO" "Installation completed successfully."
read -p "Press Enter to restart the system..."

# Wait 5 seconds before restart
log "INFO" "System will restart in 5 seconds..."
sleep 5
sudo reboot
