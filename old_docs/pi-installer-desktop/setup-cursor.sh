#!/bin/bash

# Install required packages
apt-get update
apt-get install -y x11-xserver-utils

# Create theme directory
mkdir -p /usr/share/icons/InvisibleCursor/cursors

# Copy theme files
cp cursor/transparent.png /usr/share/icons/InvisibleCursor/
cp cursor/index.theme /usr/share/icons/InvisibleCursor/
cp cursor/cursors/default /usr/share/icons/InvisibleCursor/cursors/

# Create symbolic links for all cursor types to use the transparent cursor
cd /usr/share/icons/InvisibleCursor/cursors
for cursor in arrow cross beam pointer wait hand pencil move fleur size_ver size_hor size_bdiag size_fdiag question pirate right_ptr help watch left_ptr center_ptr sb_h_double_arrow sb_v_double_arrow top_left_corner top_side top_right_corner left_side right_side bottom_left_corner bottom_side bottom_right_corner; do
    ln -sf default "$cursor"
done

# Set up X11 configuration
mkdir -p /etc/X11/xorg.conf.d
cat > /etc/X11/xorg.conf.d/50-invisible-cursor.conf << 'EOF'
Section "Device"
    Identifier "DeviceInvisibleCursor"
    Option "Cursor_name" "InvisibleCursor"
EndSection
EOF

# Create GTK3 config directory
mkdir -p /home/pi/.config/gtk-3.0
cat > /home/pi/.config/gtk-3.0/settings.ini << 'EOF'
[Settings]
gtk-cursor-theme-name=InvisibleCursor
EOF

# Create LXDE config directory
mkdir -p /home/pi/.config/lxsession/LXDE-pi
cat > /home/pi/.config/lxsession/LXDE-pi/desktop.conf << 'EOF'
[GTK]
sGtk/CursorThemeName=InvisibleCursor
EOF

# Set permissions
chown -R pi:pi /home/pi/.config

# Update icon cache
gtk-update-icon-cache -f /usr/share/icons/InvisibleCursor

# Apply cursor immediately
DISPLAY=:0 xsetroot -cursor /usr/share/icons/InvisibleCursor/cursors/default
