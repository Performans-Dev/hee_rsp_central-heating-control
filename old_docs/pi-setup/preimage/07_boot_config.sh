#!/bin/bash

echo "Configuring boot settings..."

# Set boot to desktop with autologin
sudo raspi-config nonint do_boot_behaviour B4

# Ensure systemd target is graphical
sudo systemctl set-default graphical.target

echo "Boot configuration complete."
