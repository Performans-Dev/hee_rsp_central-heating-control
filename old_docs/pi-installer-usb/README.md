# Heethings Raspberry Pi Installer

This folder contains the installation wizard and required files for setting up Heethings Central Heating Control on a Raspberry Pi.

## Contents

- `install.sh` - The main installation wizard (GUI)
- `autorun.sh` - Autorun script for USB insertion
- `setup-autorun.sh` - Script to enable USB autorun on Raspberry Pi
- `prepare-usb.sh` - Script to prepare USB drives for distribution
- `scripts/` - Installation scripts and utilities
  - `setup.sh` - Main setup script
  - `network-check.sh` - Network connectivity verification
  - `display-setup.sh` - Display and VNC configuration
- `services/` - System service definitions
- `config/` - Configuration templates

## For Manufacturers

### Preparing USB Drives for Distribution

1. On a Linux/Mac system, run the preparation script:
   ```bash
   ./prepare-usb.sh
   ```
2. Follow the instructions to format and copy files to the USB drive
3. The USB drive will be ready for distribution

### First-Time Pi Setup

On each new Raspberry Pi (one-time setup):
1. Copy and run the setup script:
   ```bash
   ./setup-autorun.sh
   ```
2. The Pi is now ready to auto-run the installer from USB

## For End Users

Simply insert the prepared USB drive into the Raspberry Pi. The installer will start automatically.

If autorun doesn't work:
1. Open a terminal
2. Navigate to the mounted USB drive (usually labeled 'HEETHINGS')
3. Run:
   ```bash
   ./install.sh
   ```

## Requirements

- Raspberry Pi with display
- Internet connection
- At least 30 minutes for installation

## Support

For support, please contact: support@heethings.com
