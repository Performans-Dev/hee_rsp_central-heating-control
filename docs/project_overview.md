# Central Heating Control Project Overview

## Project Information
- **Name**: Central Heating Control
- **Version**: 1.0.43+1043
- **Description**: Central Heating Control system by Heethings
- **Platform**: Cross-platform with focus on Raspberry Pi

## Project Architecture

### 1. Core Structure
The project follows a clean architecture pattern with three main layers:

```
lib/app/
├── core/         # Core functionality, utilities, and constants
├── data/         # Data layer (models, services, repositories)
└── presentation/ # UI layer (screens, components, widgets)
```

### 2. Key Features
1. **Hardware Communication**
   - Serial port communication via `flutter_libserialport`
   - GPIO control using `rpi_gpio` and `dart_periphery`
   - SPI communication through custom `rpi_spi` module

2. **Device Management**
   - Heater device control and monitoring
   - Output channel management
   - Device settings and configuration

3. **User Interface**
   - Material Design implementation
   - Custom on-screen keyboard (Turkish)
   - Screen saver functionality
   - Dark/Light theme support
   - QR code generation

4. **Data Management**
   - SQLite database using `sqflite_common_ffi`
   - Local storage with `get_storage`
   - State management using GetX

### 3. Dependencies

#### Core Dependencies
- **State Management**: `get` (^4.6.6)
- **Database**: `sqflite_common_ffi` (^2.3.3)
- **Hardware Communication**:
  - `flutter_libserialport` (^0.4.0)
  - `rpi_gpio` (^0.9.1)
  - `dart_periphery` (^0.9.6)

#### UI Dependencies
- `flutter_svg` (^2.0.10+1)
- `google_fonts` (^6.2.1)
- `flutter_smart_dialog` (^4.9.7+9)
- `flutter_markdown` (^0.7.3+1)

#### Custom Modules
- `on_screen_keyboard_tr`
- `screen_saver`
- `rpi_spi`

### 4. Development Environment
- **Dart SDK**: >=3.3.3 <4.0.0
- **Flutter**: Latest stable version
- **Development OS**: macOS
- **Target OS**: Linux (Raspberry Pi)

### 5. Project Structure

```
CHC/
├── assets/      # Images and static resources
├── docs/        # Project documentation
├── lib/         # Main source code
├── modules/     # Custom Flutter modules
└── snap/        # Snap package configuration
```

### 6. Configuration Files
- `pubspec.yaml`: Project configuration and dependencies
- `analysis_options.yaml`: Dart analysis configuration
- `.flutter-plugins`: Flutter plugin configuration
- Environment configuration through `flutter_dotenv`

### 7. Build and Deployment
- Custom launcher icons configuration
- Native splash screen setup
- Deployment scripts for Raspberry Pi
- Snap package support

## Development Guidelines

### 1. Code Organization
- Feature-based organization within the app directory
- Separation of concerns between data, presentation, and core layers
- Reusable components in presentation/components

### 2. State Management
- GetX for state management and dependency injection
- Local storage for persistent data
- Reactive programming patterns

### 3. Hardware Integration
- Abstracted hardware communication layer
- Device-specific implementations for Raspberry Pi
- Error handling for hardware communication

### 4. Testing
- Unit tests with `flutter_test`
- Hardware simulation capabilities
- Error scenario handling

## Future Considerations
1. **Performance Optimization**
   - Memory usage monitoring
   - Hardware communication optimization
   - UI rendering optimization

2. **Feature Expansion**
   - Additional device support
   - Enhanced monitoring capabilities
   - Remote control features

3. **Security**
   - Device communication encryption
   - Access control implementation
   - Secure storage for sensitive data

## Documentation
- Hardware communication implementation
- Device management protocols
- User interface guidelines
- API documentation
- Deployment guides

## Build and Deployment Instructions
```bash
# Generate splash screen
dart run flutter_native_splash:create --path=pubspec.yaml

# Generate launcher icons
dart run flutter_launcher_icons:main -f pubspec.yaml

# Deploy to Raspberry Pi
rsync -avz ~/Development/FlutterProjects/heethings/CentralHeatingControl/CHC pi@192.168.1.248:~/Development
```

## Dependencies Setup
```bash
# Required system dependencies
sudo apt-get -y install libsqlite3-0 libsqlite3-dev
```
