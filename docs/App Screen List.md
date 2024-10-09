### App Screen List
- Dashboard (Zone overview screen)
    - Zone detail (override on-off-auto commands for the devices in the zone)
        - device detail (override on-off-auto commands for the device)
- Functions (list of quick actions[list of commands])
    - Run a function
- Mode (summer, winter, holiday etc)
    - Change Mode
- Settings
    - Zones & Devices
        - Zone List
            - Add new zone
            - Edit / Remove zone
        - Device List
            - Add new device
            - Edit / Remove device
        - Sensor List
            - Add new Sensor
            - Edit / Remove sensor
    - Functions
        - add new function
        - edit / delete function
    - Weekly Plan Settings
        - Create new plan / copy from existing
        - Edit / Remove plan
    - User Management
        - User List
            - Change name, password
        - Add new user
    - Logs
        - Displays list of logs for selected time period
        - Clear logs
        - Sync logs
    - Preferences
        - Theme 
        - Lock Screen Preferences
            - Idle timer
            - Screen saver content (static color, selected picture, slideshow)
        - Language
        - Date Time Format
        - Timezone
        - Connections
            - Wifi: (SSID dropdown, Password, Test Connection button)
            - Ethernet: (Static IP, DHCP, test connection button)
            - Info: Connection name, IP, gateway, subnetmask etc.
        - Advanced
            - Check for updates
            - Hardware config
            - Diagnostics
            - Factory Reset
            - Minimize App (to return to OS)
            - Close App
            - Reboot OS
            - Shutdown OS
- Lock
- Initial Setup
    - Language Selection
    - Timezone Selection
    - DateTime Format Selection
    - Connection Settings (ethernet/wifi)
    - privacy policy
    - Terms of use
    - register device (pi)
    - login to cloud client account
        - reset password
        - create an account
    - check subscription status
    - activate device (pi+client+subscription result)
    - add tech support user
    - add an admin user 
        - add users if necessary
    - pick a theme
    - complete setup (info/onboarding screen)




### **Flutter Team Work Plan: Detailed**

---

#### **Main Tasks:**

1. **Developing Core App**
2. **Implementing Setup Process**
3. **Developing Control Loop**
4. **Developing UI for Screens**
5. **Implementing Logging System**
6. **Implementing Device Communication (GPIO, UART)**
7. **Offline Data Storage & Sync with Cloud**
8. **User Account & Role Management**
9. **Testing & Debugging**

---

### **1. Developing Core App**

- **Description:**  
  Develop the fundamental logic and architecture for the app. This will include the handling of zones, devices, settings, user interactions, and more. Core app must support offline mode, and data must be stored locally using SQLite.
  
- **Subtasks:**
  1. **Design app architecture and flow.**
  2. **Set up SQLite for local data storage.**
  3. **Develop models for zones, devices, weekly plans, and users.**
  4. **Integrate state management (e.g., Provider/Bloc).**
  5. **Implement dynamic loading and saving of zones, devices, and settings.**

---

### **2. Implementing Setup Process**

- **Description:**  
  This task will involve creating a smooth setup experience that runs when the Raspberry Pi is used for the first time or after a factory reset.

- **Subtasks:**
  1. **Language Selection Screen.**
  2. **Timezone Selection Screen.**
  3. **Date-Time Display Format Selection Screen.**
  4. **Wi-Fi/Ethernet connection setup screens.**
  5. **Register device (Pi) with the backend server.**
  6. **Client Account Login Screen (create/reset password options).**
  7. **Check subscription status and apply limits.**
  8. **Activate Device (based on client account subscription).**
  9. **Tech Support User Creation.**
  10. **Admin User Creation.**
  11. **Create additional users (if needed).**
  12. **Theme selection (light/dark/system).**
  13. **Onboarding completion screen.**

---

### **3. Developing Control Loop**

- **Description:**  
  The control loop continuously checks device statuses, the weekly plan, temperature readings, and triggers commands to devices when necessary.

- **Subtasks:**
  1. **Initialize Control Loop running at 1-second intervals.**
  2. **Check zone and device statuses, and trigger commands as necessary.**
  3. **Read temperature sensor inputs and apply thresholds to start/stop devices.**
  4. **Check the weekly plan and trigger scheduled actions.**
  5. **Handle GPIO input from buttons (manual control).**
  6. **Alarm/Emergency input: detect the reserved GPIO input and shut down all devices if triggered.**
  7. **Update UI for real-time device and zone statuses.**
  8. **Test with connected devices for reliability.**

---

### **4. Developing UI for Screens**

- **Description:**  
  Create user interfaces for each screen in the app. The UI should be intuitive and touch-friendly for the 7” display, with clear navigation.

- **Subtasks:**
  1. **Dashboard Screen:**
     - Display all zones with an overview of device statuses.
     - Quick action buttons for manual control.
  2. **Zone Detail Screen:**
     - Show all devices within a specific zone.
     - Allow on-off-auto overrides for devices.
  3. **Device Detail Screen:**
     - Control individual devices.
     - Override settings.
  4. **Functions Screen:**
     - List of quick actions (pre-defined commands).
     - UI for adding and running functions.
  5. **Mode Screen:**
     - Change modes (e.g., summer, winter, holiday).
  6. **Settings Screen:**
     - Multiple categories for settings like zones/devices, weekly plans, user management, logs, preferences, and more.
  7. **Logs Screen:**
     - Show logs for a specific period.
     - Clear or sync logs.
  8. **User Management Screen:**
     - List users, add/edit/remove users.
     - Role-based access settings.
  9. **Preferences Screen:**
     - Theme selection, language, screen settings (lock screen, screen saver).
  10. **Initial Setup Screens** (covered in Task #2).
  11. **Lock Screen:** Idle timer and password entry screen.
  
---

### **5. Implementing Logging System**

- **Description:**  
  Develop a system to log key events (device control, alarms, errors) and store them locally in a structured folder format.

- **Subtasks:**
  1. **Create log file structure: `/logfolder/year/month/day/logfile.json`.**
  2. **Ensure logging of events such as device activation, errors, and temperature readings.**
  3. **Add logs to the UI for user access and review.**
  4. **Add features to clear logs manually or automatically.**
  5. **Integrate with the OS team for automatic log syncing and cleanup when connected to the cloud.**

---

### **6. Implementing Device Communication (GPIO, UART)**

- **Description:**  
  Handle communication with devices via GPIO, UART, and SPI protocols, sending commands to connected devices based on user input and control loop evaluations.

- **Subtasks:**
  1. **Set up communication with GPIO for device control.**
  2. **Integrate with UART for communication with extension boards.**
  3. **Read and write to the GPIO pins based on the control loop decisions.**
  4. **Monitor sensor data from SPI (temperature inputs).**
  5. **Test UART communication with extension boards (digital inputs/outputs).**
  6. **Ensure commands sent are reliable and consistent.**

---

### **7. Offline Data Storage & Sync with Cloud**

- **Description:**  
  Ensure that the app works offline with local data storage, while syncing necessary data (logs, user settings) to the cloud when online.

- **Subtasks:**
  1. **Develop offline data storage using SQLite for zones, devices, users, weekly plans, etc.**
  2. **Sync data (zones, devices, logs) with the cloud when the connection is available.**
  3. **Manage data conflicts between offline and cloud versions (sync prioritization).**
  4. **Test data sync processes for reliability and edge cases (intermittent connectivity).**

---

### **8. User Account & Role Management**

- **Description:**  
  Implement user management and role-based access within the app. Different user levels have different permissions.

- **Subtasks:**
  1. **Create roles (Admin, Standard User, Tech Support).**
  2. **Develop logic for access controls based on user roles (view/control restrictions).**
  3. **Create screens for adding, editing, and removing users.**
  4. **Create login/logout functionality for switching between accounts.**
  5. **Integrate with cloud for client account sign-in and status checking.**
  6. **Ensure seamless role management in the UI.**
  
---

### **9. Testing & Debugging**

- **Description:**  
  Test the app thoroughly for bugs, performance, and responsiveness. Ensure all functionalities work as intended, especially under offline conditions.

- **Subtasks:**
  1. **Test control loop functionality and device control accuracy.**
  2. **Test UI interactions and screen responsiveness.**
  3. **Check error handling and resilience (device failures, communication loss).**
  4. **Test data sync mechanisms (offline/online transitions).**
  5. **Perform load testing on SQLite database performance.**

---

### **Flutter Team - TESTS Section**

#### **1. Core App Functionality**
- **Test data storage and retrieval** using SQLite for zones, devices, weekly plans, and users.
- **Test state management** (e.g., Provider/Bloc) to ensure smooth user interactions.
- **Test offline mode**: Ensure the app works seamlessly when the Raspberry Pi is not connected to the internet.
- **Test app flow and architecture**, ensuring the correct initialization, and transition between screens.

#### **2. Setup Process**
- **Test language selection**: Verify all supported languages display correctly and switch dynamically.
- **Test timezone selection**: Ensure the correct timezone is applied.
- **Test date-time display format**: Verify correct formatting across the app.
- **Test Wi-Fi/Ethernet connection**: Verify connection and reconnection processes.
- **Test device registration**: Check successful device registration with the backend.
- **Test client account sign-in**: Ensure both login and password reset work.
- **Test subscription status check**: Verify correct subscription restrictions are applied.
- **Test tech support/admin account creation**: Ensure users are created with the correct permissions.
- **Test theme selection**: Validate that the chosen theme is applied consistently.
- **Test onboarding process completion**: Ensure all steps are followed and completed correctly.

#### **3. Control Loop**
- **Test control loop interval**: Ensure the control loop runs and updates every second.
- **Test real-time updates**: Verify that devices/zones update in real-time on the dashboard.
- **Test temperature reading**: Validate accurate temperature readings and responses to thresholds.
- **Test manual device control**: Verify that users can manually turn devices on, off, or set them to auto.
- **Test weekly plan execution**: Ensure scheduled actions are triggered on time.
- **Test emergency shutdown (alarm input)**: Validate that when the GPIO pin is triggered, all devices are shut down instantly.

#### **4. UI & Screens**
- **Test dashboard screen**: Ensure zone and device statuses are displayed and updated in real-time.
- **Test zone detail screen**: Validate manual control over devices in a specific zone.
- **Test device detail screen**: Ensure individual device overrides work as intended.
- **Test function screen**: Ensure quick actions are executed correctly.
- **Test mode screen**: Verify that modes (summer, winter, etc.) are applied consistently.
- **Test settings screen**: Ensure all settings (zones, devices, users, preferences) can be added, edited, and removed.
- **Test logs screen**: Verify that logs can be viewed, cleared, and synced correctly.
- **Test user management screen**: Validate that users can be added/edited/removed with the correct roles.
- **Test lock screen**: Verify idle timer and password functionality.

#### **5. Logging System**
- **Test log structure**: Ensure logs are stored correctly in `/logfolder/year/month/day/logfile.json`.
- **Test log retention and cleanup**: Validate automatic and manual log deletion.
- **Test log syncing**: Ensure logs sync with the backend when connected to the internet.
- **Test logging for device control**: Verify key events like device activation and shutdown are logged.
- **Test error logging**: Ensure errors are correctly captured in the logs.

#### **6. Device Communication (GPIO, UART)**
- **Test GPIO input/output**: Ensure that GPIO signals control devices accurately.
- **Test UART communication**: Validate communication between Pi and connected extension boards.
- **Test SPI inputs**: Ensure correct sensor data (e.g., temperature) is received and processed.
- **Test GPIO button inputs**: Verify buttons trigger actions (e.g., device control).

#### **7. Offline & Cloud Sync**
- **Test offline functionality**: Verify full functionality of the app without an internet connection.
- **Test data synchronization**: Ensure smooth syncing of data (zones, devices, logs) when the Pi reconnects to the cloud.
- **Test conflict resolution**: Validate that syncing prioritizes correct data when conflicts occur between offline and cloud-stored data.

#### **8. User Account & Role Management**
- **Test role-based access**: Verify that each user role has the correct access to zones, devices, and settings.
- **Test login/logout flow**: Ensure smooth transitions between different user accounts.
- **Test role management**: Validate that Admin users can add/edit/remove users and assign roles correctly.
- **Test client account management**: Ensure limits are correctly applied for free and paid accounts.

#### **9. Performance & Resilience**
- **Test error handling**: Ensure proper handling of connection errors, device communication failures, and other edge cases.
- **Test system performance**: Validate app performance under load, especially when many devices and zones are in use.
- **Test boot-up time**: Ensure the app initializes and runs promptly on boot-up.
- **Test robustness during power loss**: Ensure the app resumes functionality properly after a power cut or restart.

These are the tests to ensure the reliability, performance, and correctness of the Flutter app.