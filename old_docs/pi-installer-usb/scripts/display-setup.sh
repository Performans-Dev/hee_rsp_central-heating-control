#!/bin/bash

# Display and VNC setup script
setup_display() {
    # Install required packages
    sudo apt-get update
    sudo apt-get install -y \
        lightdm \
        xserver-xorg-core \
        xserver-xorg-video-fbdev \
        realvnc-vnc-server

    # Configure display resolution for 7" touchscreen
    echo "hdmi_group=2" | sudo tee -a /boot/firmware/config.txt
    echo "hdmi_mode=87" | sudo tee -a /boot/firmware/config.txt
    echo "hdmi_cvt=800 480 60" | sudo tee -a /boot/firmware/config.txt
    echo "hdmi_drive=2" | sudo tee -a /boot/firmware/config.txt

    # Enable VNC
    sudo raspi-config nonint do_vnc 0

    # Configure VNC resolution
    echo "framebuffer_width=800" | sudo tee -a /boot/firmware/config.txt
    echo "framebuffer_height=480" | sudo tee -a /boot/firmware/config.txt

    return 0
}

# Run if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_display
    exit $?
fi
