# Raspberry Pi Setup Sections

This document outlines the complete setup process for Heethings Central Heating Control system, divided into two main phases:
1. Pre-Image Setup (done before creating the base image)
2. Heethings Installation (done via the installer script)

## Phase 1: Pre-Image Setup
These steps should be completed before creating the base image that will be cloned to production Pi's.

### 1.1 System Packages
```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y \
  libsqlite3-0 \
  libsqlite3-dev \
  i2c-tools \
  wget \
  curl \
  zip \
  unzip \
  git \
  build-essential \
  python3-pip
```

### 1.2 Interface Configuration
Enable:
- SSH
- VNC
- SPI
- I2C
- Serial Port
- GPIO

Disable:
- Serial Console
- 1-Wire

### 1.3 Boot Configuration
- Set boot to desktop
- Enable auto-login
- Switch to Wayland

### 1.4 Display Settings
- Disable screen blanking
- Disable on-screen keyboard
- Configure screen resolution

### 1.5 Performance Settings
- Configure GPIO fan settings

## Phase 2: Heethings Installation
These steps will be executed when user clicks "Install Heethings" from the menu.

### 2.1 Directory Structure Setup
```bash
# Base directories
mkdir -p /home/pi/Heethings
mkdir -p /home/pi/Pictures
```

### 2.2 Download Required Files
- Download images.zip
- Download sensor.zip
- Download scripts.zip

### 2.3 Extract and Setup Files
- Extract all downloaded zip files
- Set correct permissions
- Move files to appropriate locations

### 2.4 Python Environment Setup
- Create virtual environment
- Install required Python packages
- Configure Python path

### 2.5 Service Configuration
- Create systemd service for Python script
- Enable service on boot
- Configure service permissions

### 2.6 Auto-launch Configuration
- Create CC auto-launch script
- Configure desktop autostart
- Set execution permissions

### 2.7 Hardware Configuration
- Setup RTC module
- Configure I2C interface
- Set correct timezone

### 2.8 Final Steps
- Verify all installations
- Clean up temporary files
- Schedule system reboot

## Verification Checklist
- [ ] All required directories exist
- [ ] All services are running
- [ ] Auto-launch is configured
- [ ] RTC is working
- [ ] Python script is operational
- [ ] CC application launches correctly
