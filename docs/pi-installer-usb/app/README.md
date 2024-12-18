# Heethings Central Heating Control Application

## Application Structure

```
/opt/heethings/
├── cc                  # Main Flutter executable (ARM binary)
├── data/              # Application data directory
│   ├── flutter_assets # Flutter assets
│   └── icudtl.dat    # Unicode data
├── lib/               # Shared libraries
│   └── *.so          # Platform-specific libraries
└── config.json       # Application configuration
```

## Main Executable (cc)

The `cc` executable is a Flutter application compiled for ARM architecture. It:
1. Runs as a system service (via cc.service)
2. Uses hardware interfaces configured in the base Pi image
3. Starts automatically on boot

### Requirements
- Display resolution: 800x480 (7" touchscreen)
- Required interfaces: SPI, I2C, GPIO
- User permissions: gpio, dialout groups

### Configuration
The application reads its configuration from `config.json`:
```json
{
  "display": {
    "width": 800,
    "height": 480,
    "brightness": 100
  },
  "hardware": {
    "spi_device": "/dev/spidev0.0",
    "i2c_device": "/dev/i2c-1",
    "gpio_export": [17, 18, 27]
  }
}
```

### Building
To build the executable:
1. Use Flutter Linux ARM target
2. Enable platform integration
3. Bundle required assets

### Deployment
The installer:
1. Copies the executable to /opt/heethings
2. Sets correct permissions
3. Configures system service
4. Manages auto-start
