#!/bin/bash

# Set XDG_RUNTIME_DIR if not set
if [ -z "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR=/run/user/$(id -u)
fi

# Make sure zenity is installed
if ! command -v zenity >/dev/null 2>&1; then
    apt-get update && apt-get install -y zenity
fi

# Check current cursor theme
current_theme=$(grep "gtk-cursor-theme-name" /home/pi/.config/gtk-3.0/settings.ini 2>/dev/null | cut -d'=' -f2)

# Set default selection based on current theme
if [ "$current_theme" = "InvisibleCursor" ]; then
    visible_selected="FALSE"
    invisible_selected="TRUE"
else
    visible_selected="TRUE"
    invisible_selected="FALSE"
fi

# Show dialog with two buttons
choice=$(zenity --list \
    --title="Cursor Toggle" \
    --text="Choose cursor visibility:" \
    --radiolist \
    --column="Select" \
    --column="Option" \
    $visible_selected "Visible" \
    $invisible_selected "Invisible")

if [ $? -ne 0 ]; then
    exit 0
fi

update_cursor() {
    local theme=$1
    # Update GTK settings
    sed -i "s/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=$theme/" /home/pi/.config/gtk-3.0/settings.ini
    sed -i "s/sGtk\/CursorThemeName=.*/sGtk\/CursorThemeName=$theme/" /home/pi/.config/lxsession/LXDE-pi/desktop.conf
    
    # Update X resources
    echo "Xcursor.theme: $theme" > /home/pi/.Xresources
    echo "Xcursor.size: 24" >> /home/pi/.Xresources
    
    # Update system-wide X defaults
    echo "! X cursor appearance" > /etc/X11/Xresources/x11-common
    echo "Xcursor.theme: $theme" >> /etc/X11/Xresources/x11-common
    echo "Xcursor.size: 24" >> /etc/X11/Xresources/x11-common
    
    # Update X11 config
    if [ "$theme" = "InvisibleCursor" ]; then
        sed -i 's/Option "Xcursor_theme".*$/Option "Xcursor_theme" "InvisibleCursor"/' /etc/X11/xorg.conf.d/50-invisible-cursor.conf
    else
        sed -i 's/Option "Xcursor_theme".*$/Option "Xcursor_theme" "PiXflat"/' /etc/X11/xorg.conf.d/50-invisible-cursor.conf
    fi
}

case "$choice" in
    "Visible")
        if [ "$current_theme" = "InvisibleCursor" ]; then
            update_cursor "PiXflat"
        fi
        ;;
    "Invisible")
        if [ "$current_theme" != "InvisibleCursor" ]; then
            update_cursor "InvisibleCursor"
        fi
        ;;
    *)
        exit 0
        ;;
esac

# Show restart message
zenity --info \
    --title="Cursor Toggle" \
    --text="Please restart X session for changes to take effect.\n\nTo restart X session:\n1. Save your work\n2. Press Ctrl+Alt+Backspace" \
    --width=300
