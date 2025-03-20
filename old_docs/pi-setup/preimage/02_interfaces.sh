#!/bin/bash

echo "Configuring interfaces..."
# Enable interfaces
sudo raspi-config nonint do_ssh 0
sudo raspi-config nonint do_vnc 0
sudo raspi-config nonint do_spi 0
sudo raspi-config nonint do_i2c 0
sudo raspi-config nonint do_serial 0
sudo raspi-config nonint do_rgpio 0

# Disable interfaces
sudo raspi-config nonint do_onewire 1

# Switch to Wayland
sudo raspi-config nonint do_wayland_weston 0

echo "Interface configuration complete."
