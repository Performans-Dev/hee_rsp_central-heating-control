#!/bin/bash

# Set XDG_RUNTIME_DIR if not set
if [ -z "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR=/run/user/$(id -u)
fi

# Make sure zenity is installed
if ! command -v zenity >/dev/null 2>&1; then
    apt-get update && apt-get install -y zenity
fi

# Show dialog with two buttons
choice=$(zenity --list \
    --title="Cursor Toggle" \
    --text="Choose cursor visibility:" \
    --radiolist \
    --column="Select" \
    --column="Option" \
    TRUE "Visible" \
    FALSE "Invisible")

if [ $? -ne 0 ]; then
    exit 0
fi

case "$choice" in
    "Visible")
        # Switch to default cursor
        sed -i 's/gtk-cursor-theme-name=InvisibleCursor/gtk-cursor-theme-name=PiXflat/' /home/pi/.config/gtk-3.0/settings.ini
        sed -i 's/sGtk\/CursorThemeName=InvisibleCursor/sGtk\/CursorThemeName=PiXflat/' /home/pi/.config/lxsession/LXDE-pi/desktop.conf
        ;;
    "Invisible")
        # Switch to invisible cursor
        sed -i 's/gtk-cursor-theme-name=PiXflat/gtk-cursor-theme-name=InvisibleCursor/' /home/pi/.config/gtk-3.0/settings.ini
        sed -i 's/sGtk\/CursorThemeName=PiXflat/sGtk\/CursorThemeName=InvisibleCursor/' /home/pi/.config/lxsession/LXDE-pi/desktop.conf
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
