# Hardware Communication Implementation

## Overview
This document summarizes the implementation of hardware communication features in the Central Heating Control project. The changes were made on the `feature/hardware-communication` branch.

## Major Changes

### 1. Device Management
- Refactored `HeaterDevice` class to use output channels instead of relay properties
- Updated database schema (version 22) to accommodate new device structure
- Removed unused consumption unit controllers and related UI components

### 2. Communication Features
- Implemented serial communication handling in `StateController`
- Added methods for initializing and disposing of serial pins
- Added GPIO pin state management
- Created new utility file `byte.dart` for future implementations

### 3. UI Updates
- Modified device management screens (add/edit)
- Updated dropdowns and input handling for new heater device structure
- Removed deprecated UI components related to consumption units

### 4. File Structure Changes
Modified files:
- `lib/app/core/constants/keys.dart`
- `lib/app/core/utils/byte.dart` (new)
- `lib/app/data/models/heater_device.dart`
- `lib/app/data/services/bindings.dart`
- `lib/app/data/services/data.dart`
- `lib/app/data/services/state_controller.dart`
- `lib/app/presentation/components/dropdowns/channel.dart`
- `lib/app/presentation/screens/settings/management/device/settings_device_add_screen.dart`
- `lib/app/presentation/screens/settings/management/device/settings_device_edit_screen.dart`

## Dependencies
- `flutter_libserialport` for serial port communication
- `get` for state management
- Core Dart libraries: `dart:async`, `dart:convert`, `dart:typed_data`

## Next Steps
- Test the implemented functionality
- Verify serial communication
- Implement remaining utility functions in `byte.dart`
- Test GPIO pin management

## Git Information
Latest commit: 488c5a2
Branch: feature/hardware-communication
