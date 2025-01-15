#!/bin/bash

echo "Configuring display settings..."
# Create autostart directory
mkdir -p /home/pi/.config/lxsession/LXDE-pi
# Configure screen blanking and cursor through autostart
cat > /home/pi/.config/lxsession/LXDE-pi/autostart << EOF
@xset s off
@xset -dpms
@xset s noblank
@unclutter -idle 0.1 -root
EOF

# Configure GTK theme for dark mode
mkdir -p /home/pi/.config/gtk-3.0
cat > /home/pi/.config/gtk-3.0/settings.ini << EOF
[Settings]
gtk-theme-name=Arc-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=PibotoLt 10
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=0
gtk-enable-input-feedback-sounds=0
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintmedium
gtk-application-prefer-dark-theme=1
EOF

# Configure dark mode for GTK2 applications
cat > /home/pi/.gtkrc-2.0 << EOF
gtk-theme-name="Arc-Dark"
gtk-icon-theme-name="Papirus-Dark"
gtk-font-name="PibotoLt 10"
gtk-cursor-theme-name="Adwaita"
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=0
gtk-enable-input-feedback-sounds=0
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle="hintmedium"
EOF

# Configure notification timeout and panel theme
echo "Configuring notification settings and panel theme..."
mkdir -p /home/pi/.config/lxpanel/LXDE-pi/panels
cat > /home/pi/.config/lxpanel/LXDE-pi/panels/panel << EOF
# lxpanel <profile> config file
Global {
    edge=bottom
    allign=left
    margin=0
    widthtype=percent
    width=100
    height=26
    transparent=0
    tintcolor=#000000
    alpha=0
    autohide=0
    heightwhenhidden=2
    setdocktype=1
    setpartialstrut=1
    usefontcolor=1
    fontsize=10
    fontcolor=#ffffff
    usefontsize=0
    background=1
    backgroundfile=/usr/share/lxpanel/images/background-dark.png
    iconsize=24
    notifications=1
    notification_timeout=1000
}

Plugin {
    type = space
    Config {
        Size=2
    }
}

Plugin {
    type = menu
    Config {
        image=/usr/share/icons/Papirus-Dark/24x24/apps/start-here.svg
        system {
        }
        separator {
        }
        item {
            name=Run
            image=system-run
            command=run
        }
        separator {
        }
        item {
            name=Shutdown
            image=system-shutdown
            command=logout
        }
    }
}
EOF

# Set dark theme for PCManFM and configure desktop
mkdir -p /home/pi/.config/pcmanfm/LXDE-pi
cat > /home/pi/.config/pcmanfm/LXDE-pi/pcmanfm.conf << EOF
[ui]
always_show_tabs=0
max_tab_chars=32
win_width=640
win_height=480
splitter_pos=150
media_in_new_tab=0
desktop_folder_new_win=0
change_tab_on_drop=1
close_on_unmount=1
focus_previous=0
side_pane_mode=places
view_mode=icon
show_hidden=0
sort=name;ascending;
toolbar=newtab;navigation;home;
show_statusbar=1
pathbar_mode_buttons=0
common_bg=1
bg_color=#2f343f
fg_color=#ffffff
bg_color_sel=#5294e2
fg_color_sel=#ffffff

[desktop]
wallpaper_mode=color
wallpaper_common=1
desktop_bg=#2f343f
desktop_fg=#ffffff
desktop_shadow=#000000
show_wm_menu=0
sort=mtime;ascending;
show_documents=0
show_trash=0
show_mounts=0
EOF

# Set permissions for config files
chown -R pi:pi /home/pi/.config
chown pi:pi /home/pi/.gtkrc-2.0

echo "Display settings configuration complete."
