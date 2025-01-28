#!/bin/bash

# Create theme directory
mkdir -p /usr/share/icons/InvisibleCursor/cursors

# Copy theme files
cp cursor/transparent.png /usr/share/icons/InvisibleCursor/
cp cursor/index.theme /usr/share/icons/InvisibleCursor/
cp cursor/cursors/default /usr/share/icons/InvisibleCursor/cursors/

# Create symbolic links for all cursor types
cd /usr/share/icons/InvisibleCursor/cursors
for cursor in arrow cross beam pointer wait hand pencil move fleur size_ver size_hor size_bdiag size_fdiag question pirate right_ptr help watch left_ptr center_ptr sb_h_double_arrow sb_v_double_arrow top_left_corner top_side top_right_corner left_side right_side bottom_left_corner bottom_side bottom_right_corner; do
    ln -sf default "$cursor"
done

# Set up X11 configuration
mkdir -p /etc/X11/xorg.conf.d
cat > /etc/X11/xorg.conf.d/50-invisible-cursor.conf << 'EOF'
Section "InputClass"
        Identifier "Default Cursor Theme"
        MatchIsPointer "yes"
        Option "Xcursor_theme" "InvisibleCursor"
EndSection
EOF

# Create GTK3 config directory and set initial theme to PiXflat
mkdir -p /home/pi/.config/gtk-3.0
cat > /home/pi/.config/gtk-3.0/settings.ini << 'EOF'
[Settings]
gtk-cursor-theme-name=PiXflat
EOF

# Create LXDE config directory and set initial theme to PiXflat
mkdir -p /home/pi/.config/lxsession/LXDE-pi
cat > /home/pi/.config/lxsession/LXDE-pi/desktop.conf << 'EOF'
[GTK]
sGtk/CursorThemeName=PiXflat
EOF

# Add cursor theme to Xresources
cat > /home/pi/.Xresources << 'EOF'
Xcursor.theme: PiXflat
Xcursor.size: 24
EOF

# Set permissions
chown -R pi:pi /home/pi/.config /home/pi/.Xresources

# Update icon cache
gtk-update-icon-cache -f /usr/share/icons/InvisibleCursor

# Add cursor theme to system-wide X defaults
cat > /etc/X11/Xresources/x11-common << 'EOF'
! X cursor appearance
Xcursor.theme: PiXflat
Xcursor.size: 24
EOF
