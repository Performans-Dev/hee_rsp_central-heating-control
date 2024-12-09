# CHC Naming Conventions

## System Context
Central Heating Control (CHC) is a Flutter-based control system running on Raspberry Pi 4B with:
- 800x480 touchscreen interface
- Direct GPIO controls (8 DI, 8 DO, 4 ADC)
- Expandable I/O through serial extension boards
- Real-time monitoring and control of heating/cooling devices

### Hardware Architecture
- **Main Board**: Raspberry Pi 4B with direct GPIO access
- **Extension Boards**: Connected via serial (UART) for additional I/O
- **Connected Devices**: Heaters, coolers with error feedback mechanisms

### Control Philosophy
- Continuous polling of inputs and outputs
- State management with commanded vs actual states
- Error detection with threshold-based failure handling
- Extensible I/O through serial expansion boards

### Application Features
- **Zone Management**: Control and monitor heating/cooling zones
- **Device Management**: 
  - Heater configuration and control
  - Sensor setup and monitoring
- **User Management**: Access control and permissions
- **Scheduling**: Weekly planning and programming
- **System Settings**:
  - Preferences: Language, theme, timezone, date/time
  - Connectivity: Network and remote access setup
  - Advanced: Hardware configuration, diagnostics
  - Maintenance: Updates, factory reset, system reboot

## I/O Channel Types
- **DI**: Digital Input
- **DO**: Digital Output
- **ADC**: Analog to Digital Converter (Analog Input)
- **DAC**: Digital to Analog Converter (Analog Output)

## Signal Logic Types
- **NO**: Normally Open
  - Default state is 0 (open)
  - 0 = Normal/OK
  - 1 = Active/Error

- **NC**: Normally Closed
  - Default state is 1 (closed)
  - 1 = Normal/OK
  - 0 = Active/Error

## Channel System
A channel represents a single point of data flow in the system, whether it's an input or output. Each channel has:
- A board location (Main Pi or Extension Board)
- An index on that board
- A type (DI, DO, ADC, DAC)
- Signal logic type (NO/NC) for error/status signals

## State Management
Each channel maintains two distinct states:
- **Commanded State**: The desired state set by the controller (what we want)
- **Actual State**: The current state reported by hardware (what is)

### State Tracking
```dart
class ChannelState {
  bool commanded;     // Desired state set by controller
  bool actual;       // Current state reported by hardware
  DateTime lastUpdate; // Last hardware feedback time
  bool hasError;     // Mismatch between commanded and actual
}

// Usage example
Map<IOChannel, ChannelState> channelStates;
```

State mismatches between `commanded` and `actual` indicate potential hardware issues or communication failures that need attention.

## Error Handling
The system uses a threshold-based error detection mechanism:

### Error States
- **hasError**: Immediate error state (single mismatch)
- **errorCount**: Number of consecutive errors
- **isFailed**: Device is considered failed (errorCount >= threshold)

### Error Detection Logic (NC Example)
```dart
class ChannelState {
  bool commanded;
  bool actual;
  int errorCount;
  static const int errorThreshold = 3;
  
  // For NC (Normally Closed) devices:
  // - When commanded ON, expect actual = 1 (closed)
  // - Error when actual = 0 while commanded ON
  // - Reset errorCount when state matches expected
  
  bool get isFailed => errorCount >= errorThreshold;
}
```

The system will:
1. Detect state mismatches
2. Increment error counter for consecutive errors
3. Mark device as failed when threshold is reached
4. Reset counter when correct state is detected

## Polling System
The system uses two types of polling cycles to monitor and update I/O states:

### GPIO Polling
Direct, high-frequency polling of the main board's GPIO pins:
```dart
void startGPIOPolling() {
  // Rapid polling of DI/DO on main board
}
```

### Serial Polling
Command-response cycle for extension boards:
```dart
void startSerialPolling() {
  // Send command -> Wait for response -> Update states -> Next command
}
```

The polling system continuously updates the `actual` states in the state management system, which are then compared against `commanded` states to detect and handle any discrepancies.

## Hardware Management

### Board Identification
- **Main Board**: Fixed ID `0x00` (Raspberry Pi)
- **Extension Boards**: Sequential IDs starting from `0x01`

### Hardware Discovery Flow
1. **Initial State**
   - Main board (0x00) active
   - No extension boards in database

2. **New Hardware Detection**
   ```dart
   class ExtensionBoard {
     int id;                // Board ID (0x01, 0x02, ...)
     String serialNumber;   // Unique serial number
     String hwVersion;      // Hardware version
     String fwVersion;      // Firmware version
     bool isActive;         // Current connection status
   }
   ```

3. **Addition Process**
   ```mermaid
   flowchart TD
     A[New Board Plugged] --> B[Show Add Hardware Screen]
     B --> C[Display Next Available ID]
     C --> D[User Sets Board ID]
     D --> E[Send Test Command]
     E --> F{Response OK?}
     F -->|Yes| G[Query Board Info]
     G --> H[Save to Database]
     F -->|No| I[Show Error]
     H --> J[Begin Normal Operation]
   ```

4. **Validation Commands**
   ```dart
   // Test command structure
   const testCommand = 0xAA;  // Example command code
   
   // Board info query
   class BoardInfo {
     final String serialNumber;
     final String hardwareVersion;
     final String firmwareVersion;
   }
   ```

The system maintains the board registry in the database and ensures unique IDs across all extension boards.

## Code Examples
```dart
// Channel definitions for a heater with error feedback and level control
IOChannel heaterErrorInput = IOChannel(
  board: Board.mainPi, 
  index: 2, 
  type: ChannelType.input
);

IOChannel heaterLevel1Output = IOChannel(
  board: Board.extension1, 
  index: 0, 
  type: ChannelType.output
);

```
