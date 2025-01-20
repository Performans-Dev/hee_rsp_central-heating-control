# Heethings Central Heating Control (CHC)

Central Heating Control system for Raspberry Pi, featuring automated control, diagnostics, and updates.

## Recent Updates

### Installation Improvements (January 2025)
- Renamed command shortcuts with `heethings-` prefix for uniqueness:
  - `heethings-cc`: Main control application
  - `heethings-cc-elevator`: Update manager
  - `heethings-cc-diagnose`: Diagnostic tool
- Enhanced autostart configuration for reliable startup
- Improved backup management system:
  - Automatic backup before installation
  - Keeps last 3 backups
  - Organized backup storage in `/home/pi/heethings_backups/`
- Added comprehensive logging throughout installation process
- Improved error handling and user feedback

## Installation

### Prerequisites
- Raspberry Pi (tested on Pi 4)
- Raspbian OS
- Internet connection for updates
- Display for initial setup

### Quick Install (Terminal)
```bash
# 1. Clone the repository
git clone https://github.com/yourusername/heethings.git

# 2. Run installation script
cd heethings/docs/pi-setup/postimage
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
A user-friendly graphical installer is planned with the following features:

#### Phase 1: Basic GUI
- [ ] Welcome screen with installation options
- [ ] Progress indicators for installation steps
- [ ] Basic error handling and user feedback
- [ ] Simple backup management interface

#### Phase 2: Advanced Features
- [ ] Component selection for custom installations
- [ ] Network configuration interface
- [ ] Advanced backup management
  - [ ] Backup browsing and selection
  - [ ] Backup verification
  - [ ] Selective restore options
- [ ] System health checks

#### Phase 3: Enhanced User Experience
- [ ] Installation wizards for different use cases
- [ ] Real-time system monitoring during installation
- [ ] Automatic problem detection and resolution
- [ ] User preference configuration
- [ ] Multi-language support

### Technical Roadmap
1. Create Flutter-based installer GUI
2. Modularize existing shell scripts for GUI integration
3. Implement background service for installation tasks
4. Add error recovery and rollback capabilities
5. Create comprehensive logging and debugging system

## Contributing
Contributions are welcome! Please read our contributing guidelines and submit pull requests to our repository.

## License
[Your License Here]

## Support
For support, please open an issue in the GitHub repository or contact our support team.
