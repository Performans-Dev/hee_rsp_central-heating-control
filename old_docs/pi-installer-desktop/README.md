# Heethings Installer for Raspberry Pi

This directory contains scripts for installing Heethings Central Heating Control on a Raspberry Pi.

## Components

- `setup-shortcut.sh`: Creates an installer shortcut in the applications menu and sets up the main installation script
- `install.sh`: (Created by setup-shortcut.sh) Performs the actual installation

## Features

The installer:
1. Enables required interfaces (SPI, I2C, Serial)
2. Sets up Real-Time Clock (RTC)
3. Downloads and installs:
   - Main Flutter application
   - Elevator app
   - Diagnostic app
   - Support files (images, sensor scripts)
4. Configures system:
   - Sets desktop wallpaper
   - Sets boot splash screen
   - Downloads screensaver images
   - Creates application shortcuts
   - Sets up autostart
5. Installs required packages:
   - libsqlite3-0
   - libsqlite3-dev
   - i2c-tools
   - jq

## Installation

1. Copy `setup-shortcut.sh` to the Raspberry Pi
2. Run:
   ```bash
   sudo ./setup-shortcut.sh
   ```
3. Click "Install Heethings" in the applications menu
4. Follow the prompts to complete installation

## Notes

- The installer requires root privileges
- The system will reboot after installation
- All files are installed under `/home/pi/Heethings`
- Screensaver images are stored in `/home/pi/Pictures`
