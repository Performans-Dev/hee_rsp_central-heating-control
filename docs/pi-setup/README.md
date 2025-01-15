# Heethings Central Control System Setup

This directory contains scripts for setting up the Heethings Central Control System on a Raspberry Pi.

## Image Preparation (For Distributors)

1. Start with a fresh Raspbian installation
2. Navigate to the CHC directory and copy the setup files to the Raspberry Pi:
   ```bash
   cd /path/to/CHC
   rsync -av --exclude='.git' docs/pi-setup/ pi@raspberrypi:/home/pi/pi-setup/
   ```
3. Make preimage scripts executable:
   ```bash
   ssh pi@raspberrypi "chmod +x /home/pi/pi-setup/preimage/*.sh"
   ```
4. Run the pre-image setup:
   ```bash
   ssh pi@raspberrypi "cd /home/pi/pi-setup/preimage && sudo ./run_preimage_setup.sh"
   ```
5. Wait for the script to complete and the system to reboot
6. Create an image of the SD card for distribution

## Customer Installation

When a customer receives a Raspberry Pi with the pre-configured image:

1. Power on the Raspberry Pi
2. Click the "Install Heethings" icon in System Tools
3. Confirm the installation in the warning dialog
4. Wait for the installation to complete
5. The system will automatically reboot
6. After reboot, the Central Control system will start automatically

## Script Details

### Pre-Image Setup (preimage/*.sh)
- `01_packages.sh`: Installs required system packages
- `02_interfaces.sh`: Configures network and system interfaces
- `03_display_settings.sh`: Sets up display and theme preferences
- `04_static_assets.sh`: Downloads and configures static assets
- `05_hardware_config.sh`: Configures hardware settings
- `06_menu_setup.sh`: Creates the installer menu item
- `07_boot_config.sh`: Sets up boot configuration

### Post-Image Setup (postimage/*.sh)
- `01_directory_setup.sh`: Creates necessary directories
- `02_download_apps.sh`: Downloads latest CC applications
- `03_service_setup.sh`: Configures system services
- `04_database_setup.sh`: Sets up databases
- `05_final_setup.sh`: Performs final configuration
- `install_heethings.sh`: Main installation script

## Directory Structure

```
pi-setup/
├── preimage/                 # Scripts for image preparation
│   ├── run_preimage_setup.sh # Pre-image setup wrapper
│   ├── 01_packages.sh
│   ├── 02_interfaces.sh
│   ├── 03_display_settings.sh
│   ├── 04_static_assets.sh
│   ├── 05_hardware_config.sh
│   ├── 06_menu_setup.sh
│   └── 07_boot_config.sh
└── postimage/               # Scripts for final installation
    ├── install_heethings.sh # Main installation script
    ├── 01_directory_setup.sh
    ├── 02_download_apps.sh
    ├── 03_service_setup.sh
    ├── 04_database_setup.sh
    └── 05_final_setup.sh
```

## Notes

- The pre-image setup only needs to be run once when preparing the distribution image
- The installation script (`install_heethings.sh`) can be run multiple times safely:
  - Includes backup functionality for existing installations
  - Shows warning dialog before proceeding
  - Preserves user data during reinstallation
- All configurations are designed to work with minimal user interaction
- The system will automatically reboot after installation when necessary
