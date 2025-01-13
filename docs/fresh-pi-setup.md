# Fresh Raspberry Pi Setup Checklist

Before installing the CC bundle, complete all items in this checklist to prepare your Raspberry Pi.

## 1. Required Packages
- [ ] Install required system packages:
  ```bash
  # Update package list and upgrade system
  sudo apt update
  sudo apt upgrade -y
  
  # Install required packages
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

## 2. Interfaces
Using `raspi-config` or Raspberry Pi Configuration tool:

### Enable These:
- [ ] SSH (should be enabled by default)
- [ ] VNC
- [ ] SPI
- [ ] I2C
- [ ] Serial Port
- [ ] GPIO

### Disable These:
- [ ] Serial Console
- [ ] 1-Wire

### Terminal Commands (Alternative Method):
```bash
# Enable interfaces
sudo raspi-config nonint do_ssh 0
sudo raspi-config nonint do_vnc 0
sudo raspi-config nonint do_spi 0
sudo raspi-config nonint do_i2c 0
sudo raspi-config nonint do_serial 0
sudo raspi-config nonint do_rgpio 0

# Disable interfaces
sudo raspi-config nonint do_serial 1
sudo raspi-config nonint do_onewire 1
```

## 3. Boot Configuration
- [ ] Set to boot to desktop
- [ ] Enable auto-login
- [ ] Switch to Wayland:
  ```bash
  # Edit the environment file
  sudo raspi-config nonint do_wayland 0
  
  # Or manually edit /etc/gdm3/daemon.conf and uncomment:
  # WaylandEnable=true
  ```

### Terminal Commands:
```bash
# Set boot to desktop with autologin
sudo raspi-config nonint do_boot_behaviour B4

# Enable Wayland
sudo raspi-config nonint do_wayland 0
```

## 4. Performance
- [ ] Configure GPIO fan settings in `/boot/firmware/config.txt`:
  ```bash
  # Add these lines using:
  echo "dtoverlay=gpio-fan,gpiopin=7,temp=65000" | sudo tee -a /boot/firmware/config.txt
  ```
  This configures:
  - GPIO Pin: #7
  - Temperature Threshold: 65°C

## 5. Display Settings
- [ ] Disable screen blanking
- [ ] Disable on-screen keyboard
- [ ] Ensure screen resolution is set correctly

### Method 1: Using Desktop Environment
If you're working directly on the Raspberry Pi or via VNC:
```bash
xset s off
xset -dpms
xset s noblank
```

### Method 2: Using Configuration Files
If you're connected via SSH:
```bash
# Disable screen blanking by editing the autostart file
sudo mkdir -p /etc/xdg/lxsession/LXDE-pi
sudo bash -c 'cat > /etc/xdg/lxsession/LXDE-pi/autostart << EOF
@xset s off
@xset -dpms
@xset s noblank
EOF'

# Also disable screen blanking in lightdm
sudo bash -c 'echo "[SeatDefaults]
xserver-command=X -s 0 -dpms" > /etc/lightdm/lightdm.conf.d/01_nodpms.conf'
```

## 6. Appearance Settings
- [ ] Select dark theme in Appearance Settings
- [ ] Download CHC wallpaper
- [ ] Set wallpaper as desktop background
  > Note: Wallpaper must be set manually as it cannot be automated

## 7. Additional Settings
- [ ] Disable rainbow splash screen and overscan:
  ```bash
  # Add these lines to /boot/firmware/config.txt:
  echo "disable_overscan=1" | sudo tee -a /boot/firmware/config.txt
  echo "disable_splash=1" | sudo tee -a /boot/firmware/config.txt
  ```

## 8. Desktop Shortcut Setup
- [ ] Copy the setup shortcut script from development machine to Raspberry Pi:
  ```bash
  # From your development machine, run:
  scp /Users/io/Development/FlutterProjects/heethings/CentralHeatingControl/CHC/docs/pi-installer-desktop/setup-shortcut.sh pi@raspberrypi.local:/home/pi/
  
  # SSH into Raspberry Pi and run:
  ssh pi@raspberrypi.local
  
  # Make it executable and run
  sudo chmod +x /home/pi/setup-shortcut.sh
  sudo ./setup-shortcut.sh
  ```
  This will:
  - Create a desktop shortcut for the installer
  - Generate the installation script
  - Set up proper permissions

After completing all items, reboot your Raspberry Pi:
```bash
sudo reboot
```

Then proceed with CC bundle installation.
