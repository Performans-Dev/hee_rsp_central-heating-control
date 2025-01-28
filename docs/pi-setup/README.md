# Heethings Pi Setup

> **Context Note**: This repository was migrated from the main CHC project to create a dedicated installation scripts project. The migration allows for better organization and focused development of the installation process, particularly for the upcoming GUI-based installer.

This directory contains scripts and instructions for setting up Heethings Central Heating Control on a Raspberry Pi.

## Directory Structure

```
pi-setup/
├── preimage/           # Scripts run before system image creation
├── postimage/          # Scripts run after first boot
└── README.md          # This file
```

## Recent Updates (January 2025)

### Command Shortcuts
- All commands now use `heethings-` prefix for uniqueness:
  - `heethings-cc`: Main control application
  - `heethings-cc-elevator`: Update manager
  - `heethings-cc-diagnose`: Diagnostic tool

### Installation Improvements
- Enhanced autostart configuration
- Improved backup management:
  - Automatic backup before installation
  - Keeps last 3 backups in `/home/pi/heethings_backups/`
  - Automatic cleanup of old backups
- Added comprehensive logging
- Improved error handling

## Installation Guide

### Prerequisites
- Raspberry Pi (tested on Pi 4)
- Raspbian OS
- Internet connection
- Display for initial setup

### Quick Install
```bash
# 1. Run preimage setup (if not already done)
cd preimage
sudo ./run_preimage_setup.sh

# 2. Run postimage setup after reboot
cd ../postimage
sudo ./install_heethings.sh
```

### Command Reference
```bash
# Main Control Application
sudo heethings-cc

# Update Manager
sudo heethings-cc-elevator

# Diagnostic Tool
sudo heethings-cc-diagnose
```

## Upcoming Features

### GUI Installer (Planned)
A user-friendly graphical installer is planned to replace the terminal-based postimage setup:

#### Phase 1: Basic GUI (Q1 2025)
- [ ] Welcome screen with installation options
  - Fresh install
  - Update existing
  - Restore from backup
- [ ] Visual progress indicators
- [ ] Basic error handling with user-friendly messages
- [ ] Simple backup management interface

#### Phase 2: Advanced Features (Q2 2025)
- [ ] Component selection for custom installations
- [ ] Network configuration interface
- [ ] Advanced backup management
  - Backup browsing and selection
  - Backup verification
  - Selective restore options
- [ ] System health checks

#### Phase 3: Enhanced UX (Q3 2025)
- [ ] Installation wizards
- [ ] Real-time system monitoring
- [ ] Automatic problem detection
- [ ] User preference configuration
- [ ] Multi-language support

### Technical Implementation Plan
1. Create Flutter-based installer GUI
   - Modular design for easy updates
   - Responsive layout for different screens
   - Offline-first architecture

2. Script Integration
   - Modularize existing shell scripts
   - Create service layer for GUI
   - Add IPC for script communication

3. Background Service
   - Installation task management
   - Progress monitoring
   - Error handling and recovery

4. Testing and Documentation
   - Automated testing suite
   - User documentation
   - Developer guides

## Development

### Setup Development Environment
```bash
# Coming soon with GUI implementation
```

### Testing
```bash
# Coming soon with GUI implementation
```

## Troubleshooting

### Common Issues
1. **Installation fails**: Check logs in `/var/log/heethings/install.log`
2. **Backup fails**: Ensure enough disk space in `/home/pi/heethings_backups/`
3. **Autostart issues**: Check `/home/pi/.config/autostart/` permissions

### Getting Help
- Open an issue in the GitHub repository
- Check the logs for detailed error messages
- Contact support team for assistance
