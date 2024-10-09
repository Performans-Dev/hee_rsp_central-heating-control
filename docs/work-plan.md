

### 1. **Hardware Team (Raspberry Pi Integration Board)**

**Tasks:**
- Design and create a custom board that integrates with the Raspberry Pi.
- Ensure GPIO connectivity for 8 inputs and 8 outputs.
- Connect 4 hardware buttons for general purposes via GPIO.
- Design connectors for relays, UART, SPI, and inputs/buttons routed to GPIO.
- Ensure reliable power delivery, including battery backup for timekeeping on the Pi.
- Validate all hardware components through testing with the Raspberry Pi and custom extension boards.

**Milestones:**
- Prototype board design completion.
- Final hardware design and testing.
- Manufacturing and assembly of production units.

**Dependencies:** Collaboration with the Embedded Software Team for hardware-software communication validation.

---

### 2. **Hardware Team (Serial Extension Boards)**

**Tasks:**
- Design and build the serial extension boards with 6 digital inputs, 6 digital outputs, and one NTC analog input.
- Ensure daisy-chaining/multiple board support via UART.
- Optimize power consumption and ensure signal integrity over serial communication.
- Design connectors for easy installation and integration with the main board.
- Prototype, test, and manufacture serial extension boards.

**Milestones:**
- Initial board prototype design.
- Testing of communication and board functionality with the Raspberry Pi.
- Mass production and final testing.

**Dependencies:** Coordinate with Embedded Software Team for firmware programming and testing.

---

### 3. **Embedded Software Team**

**Tasks:**
- Write firmware in C for the serial extension boards.
- Implement communication protocol between the Raspberry Pi and extension boards via UART.
- Handle real-time data processing (inputs/outputs) on the extension boards.
- Write control logic for NTC analog input (temperature sensor).
- Provide regular firmware updates for potential hardware changes and improvements.

**Milestones:**
- Basic firmware implementation for UART communication.
- Full implementation of input/output control and NTC sensor.
- Testing and debugging with Hardware Team and Flutter Team.
- Final production-ready firmware.

**Dependencies:** Work closely with Hardware Teams (both) and ensure compatibility with the Flutter app for control logic.

---

### 4. **Flutter Team**

**Tasks:**
- Develop the Flutter app for the Raspberry Pi with a 7" touchscreen interface.
- Implement features for zone creation, device control, and port selection via the UI.
- Integrate SQLite for local storage of zones, devices, and weekly plans.
- Develop a controller loop that runs every second to monitor device statuses, time, and temperatures, sending commands through GPIO.
- Ensure that the app can run offline after initial account login.
- Implement GPIO, SPI, and UART communication for device control.
- Create a settings panel for account management and system preferences.
- Add OTA update support and integrate with the backend for updates.

**Milestones:**
- UI Design and first prototype with basic functionality.
- SQLite integration and basic device control.
- Full implementation of GPIO/SPI/UART communication.
- Final testing and bug fixing with other teams.

**Dependencies:** Collaboration with the OS Team (for OTA updates and app startup) and Backend Team for initial login and OTA integration.

---

### 5. **OS Team**

**Tasks:**
- Set up Raspbian to run the Flutter app on startup.
- Implement mechanisms for secure over-the-air (OTA) updates of the Flutter app.
- Manage system security, including securing Raspbian from unauthorized access.
- Optimize performance and boot times for the Raspberry Pi.
- Enable automatic time synchronization using the battery backup system for timekeeping.
- Provide detailed documentation on setting up and maintaining the platform.

**Milestones:**
- Initial Raspbian configuration and app startup test.
- OTA update system implementation.
- Final system security audit and testing.

**Dependencies:** Collaborate with the Flutter Team to ensure app runs seamlessly on startup and with the Backend Team for the OTA infrastructure.

---

### 6. **Backend Team**

**Tasks:**
- Design and build the database/server structure for device management, account login, and OTA updates.
- Develop and implement an identity server for secure login and management of Pi devices.
- Create an API that enables each Pi to log in to an account at least once, ensuring offline functionality after initial login.
- Set up an OTA update system for sending app updates to Pi devices.
- Implement analytics and logging system for tracking device statuses, updates, and user activity.

**Milestones:**
- Identity server setup and API development for login.
- Database and API implementation for device and zone data.
- Finalizing the OTA update mechanism and distribution.

**Dependencies:** Work closely with the Flutter Team for app communication and OTA updates, as well as with the OS Team for platform integration.







# 1.1

Let’s start with **Hardware Task #1** for the Raspberry Pi integration board.

### **Task Name:**  
**Raspberry Pi Integration Board Design**

---

### **Description:**  
This task focuses on designing and creating a custom board that integrates seamlessly with the Raspberry Pi to control devices via GPIO, UART, and SPI interfaces. The custom board must allow for the connection of relays, sensors, and hardware buttons and ensure stable operation, including adding a battery backup for timekeeping.

---

### **Research & Development Works:**

#### 1. **Pinout & Compatibility Research**
   - **Research Topics:**
     - Raspberry Pi 4 GPIO pinout.
     - Voltage levels and power requirements.
     - Best practices for connecting GPIO, SPI, and UART devices.
   - **Development:**
     - Map the available GPIO pins for inputs, outputs, relays, buttons, and analog sensors.
     - Ensure proper level shifting if external hardware uses different voltage levels.

#### 2. **Power Supply and Battery Backup**
   - **Research Topics:**
     - Battery backup solutions for Raspberry Pi.
     - Circuit designs for timekeeping during power-off.
     - Efficient power supply design for low consumption during idle.
   - **Development:**
     - Add a Real-Time Clock (RTC) module and ensure the board can keep time when powered off.
     - Implement power management circuits (e.g., voltage regulators, protection circuits).

#### 3. **GPIO Handling**
   - **Research Topics:**
     - How to design circuits for controlling devices via GPIO (relays, lights, heaters, etc.).
     - Designing debounce circuits for hardware buttons.
     - Handling input/output signals with protection circuits.
   - **Development:**
     - Design circuits for 8 GPIO inputs and 8 GPIO outputs, ensuring isolation where needed (e.g., using optocouplers).
     - Design connection points for easy access and troubleshooting.

#### 4. **UART and SPI Interfacing**
   - **Research Topics:**
     - UART communication standards and connectors for serial extension boards.
     - SPI communication for analog sensors and data transfer.
   - **Development:**
     - Design UART connector for seamless integration with the serial extension boards.
     - Implement SPI interfaces to handle the 4 analog inputs, ensuring stable data transmission.

#### 5. **Relay and Sensor Connectivity**
   - **Research Topics:**
     - Relay types (e.g., solid-state vs mechanical).
     - Design considerations for sensor integration (temperature sensors, switches).
   - **Development:**
     - Implement connectors for relays to control external devices (heaters, coolers, etc.).
     - Design circuits to connect various sensors such as temperature and switches.

#### 6. **Testing & Prototyping**
   - **Research Topics:**
     - Methods to test GPIO, SPI, and UART circuits.
     - Simulation tools for verifying circuit design.
   - **Development:**
     - Create a prototype board with test points for easy debugging.
     - Run functional tests to ensure proper data transmission and power distribution.

#### 7. **Manufacturing and Final Design**
   - **Research Topics:**
     - PCB layout tools (Altium, Eagle, KiCad).
     - Cost-effective manufacturing options.
   - **Development:**
     - Design a compact, cost-efficient PCB layout.
     - Prepare for large-scale production after final testing and validation.

---

This is the breakdown for **Hardware Task #1**. Let me know when you’re ready to dive deeper or move to the next task!





### **Hardware Task #2:**  
**Serial Extension Board Design**

---

### **Description:**  
This task focuses on designing and creating serial extension boards that extend the Raspberry Pi's input/output capabilities via UART. Each extension board will have 6 digital inputs, 6 digital outputs, and one NTC analog input for temperature measurement. These boards must support daisy-chaining to allow multiple boards to be connected via a single UART interface.

---

### **Research & Development Works:**

#### 1. **Serial Communication Protocol**
   - **Research Topics:**
     - UART communication protocol standards and how to handle multiple boards on a single bus.
     - Design of custom serial communication protocols for data exchange between Raspberry Pi and extension boards.
   - **Development:**
     - Define a message structure and protocol for reliable data transfer between boards (e.g., address-based communication for each board).
     - Implement error-checking mechanisms (e.g., CRC, parity checks) to ensure data integrity.

#### 2. **Daisy-Chaining Multiple Boards**
   - **Research Topics:**
     - Methods for addressing multiple devices over UART.
     - Power and signal propagation over long chains of devices.
   - **Development:**
     - Design addressable extension boards that can communicate with Raspberry Pi individually or in a group.
     - Implement connectors that allow easy linking of multiple boards, ensuring signal integrity and power delivery across boards.

#### 3. **Digital Input/Output Circuit Design**
   - **Research Topics:**
     - Design of input/output circuits that handle 6 digital inputs and 6 digital outputs per board.
     - Protecting inputs from noise, over-voltage, or incorrect wiring.
     - Implementing optocouplers or other isolation techniques for output relays.
   - **Development:**
     - Design robust digital input circuits capable of handling different voltage levels (e.g., 3.3V or 5V).
     - Design output drivers (transistors or MOSFETs) capable of controlling relays or other devices.
     - Test the I/O with real-world devices (e.g., switches, relays, LEDs) to ensure functionality.

#### 4. **NTC Temperature Sensor Integration**
   - **Research Topics:**
     - Understanding NTC thermistors and how to design circuits for accurate temperature measurement.
     - Analog-to-digital conversion (ADC) strategies for reading temperature data from the NTC sensor.
   - **Development:**
     - Design an analog input circuit to read data from the NTC thermistor.
     - Calibrate the analog input for accurate temperature readings over the operating range of the system.

#### 5. **Power Supply for Extension Boards**
   - **Research Topics:**
     - Power supply design for serial extension boards that can handle multiple chained units.
     - Power distribution strategies to ensure stable voltage levels across all chained boards.
   - **Development:**
     - Design efficient power management circuits, with voltage regulation and protection.
     - Implement power connectors that ensure reliable power delivery across multiple chained boards.

#### 6. **Board Addressing & Configuration**
   - **Research Topics:**
     - Methods for assigning unique addresses to each serial extension board (e.g., DIP switches, auto-addressing).
   - **Development:**
     - Implement an addressing mechanism that allows each board to be easily identified on the UART bus.
     - Create configuration options for setting board-specific parameters (e.g., which inputs/outputs to activate).

#### 7. **Testing & Prototyping**
   - **Research Topics:**
     - Techniques for testing UART communication and I/O circuits under different loads.
     - Debugging tools for real-time monitoring of serial data.
   - **Development:**
     - Build a prototype extension board and test it with the Raspberry Pi.
     - Verify the digital I/O functionality and NTC temperature readings in real-world conditions.
     - Test the daisy-chaining of multiple boards to ensure stable communication and power delivery.

#### 8. **Manufacturing and Final Design**
   - **Research Topics:**
     - PCB design tools and practices for creating multi-layer boards.
     - Cost-effective manufacturing solutions for low-volume or high-volume production.
   - **Development:**
     - Design the final PCB layout, considering space for connectors, power supply, and UART daisy-chaining.
     - Prepare the board for mass production, ensuring it meets all required safety and performance standards.

---

This is the breakdown for **Hardware Task #2: Serial Extension Board Design**. Let me know if you’d like to move to the next task!





### **Embedded Software Task #1:**  
**Firmware Development for Serial Extension Boards**

---

### **Description:**  
The Embedded Software Team is responsible for developing firmware in C for the serial extension boards. The firmware will handle communication with the Raspberry Pi via UART, process input/output data, and manage the NTC analog input for temperature sensing. The software must be designed to support multiple boards in a daisy-chained setup and ensure real-time processing.

---

### **Research & Development Works:**

#### 1. **UART Communication Protocol Implementation**
   - **Research Topics:**
     - Serial communication standards (UART) and data framing for reliable transmission.
     - Techniques for handling communication with multiple addressable devices over a shared bus.
   - **Development:**
     - Implement a custom communication protocol for exchanging data between the Raspberry Pi and the extension boards (addressing, data frames, and commands).
     - Integrate error detection mechanisms (e.g., CRC, parity bits) to ensure data integrity.
     - Develop functions for sending and receiving data packets, handling potential communication delays or failures.

#### 2. **Real-Time I/O Processing**
   - **Research Topics:**
     - Techniques for real-time data processing in embedded systems (interrupts, polling, etc.).
     - Methods to handle digital input/output events efficiently.
   - **Development:**
     - Implement firmware routines to read 6 digital inputs and control 6 digital outputs.
     - Ensure the system processes inputs in real-time, with minimal latency.
     - Write efficient I/O control routines that can handle multiple devices without slowing down the system.

#### 3. **NTC Analog Input Processing**
   - **Research Topics:**
     - How to read and convert NTC thermistor analog signals to digital values using an ADC (analog-to-digital converter).
     - Calibration techniques for ensuring accurate temperature measurements.
   - **Development:**
     - Write firmware to read the analog input from the NTC sensor.
     - Implement an ADC conversion routine to translate analog signals into temperature data.
     - Calibrate the firmware to ensure temperature readings are accurate and responsive.

#### 4. **Daisy-Chaining and Board Addressing**
   - **Research Topics:**
     - Methods for addressing multiple devices on a single bus (addressing schemes, ID assignment).
     - Techniques for handling communication in daisy-chained systems without conflict.
   - **Development:**
     - Implement board addressing routines so that each serial extension board can be uniquely identified.
     - Develop communication logic to ensure only the addressed board responds to commands.
     - Test the firmware with multiple boards connected to ensure smooth communication and no data collision.

#### 5. **Interrupt-Driven I/O and Event Handling**
   - **Research Topics:**
     - Using interrupts in embedded systems for real-time responsiveness.
     - Implementing interrupt-driven communication and I/O handling to reduce CPU load.
   - **Development:**
     - Write interrupt service routines (ISRs) for UART communication and I/O changes.
     - Implement event-driven I/O handling to detect input changes or output events in real time.

#### 6. **Memory and Resource Optimization**
   - **Research Topics:**
     - Techniques for optimizing memory usage in embedded systems.
     - Strategies for minimizing CPU usage while maintaining real-time performance.
   - **Development:**
     - Optimize memory usage in the firmware to ensure it can run on resource-constrained microcontrollers.
     - Implement resource-efficient data structures and communication buffers for handling UART data and I/O events.
   
#### 7. **Testing & Debugging**
   - **Research Topics:**
     - Techniques for testing embedded systems and debugging communication protocols (e.g., using logic analyzers, serial debugging).
     - Strategies for validating real-time I/O processing and temperature readings.
   - **Development:**
     - Develop test scripts to simulate UART communication with the Raspberry Pi and monitor responses.
     - Test I/O processing and ensure reliable digital input/output handling under real-world conditions.
     - Debug and troubleshoot the firmware in different scenarios (e.g., single board vs. multiple boards).

#### 8. **Firmware Update Mechanism**
   - **Research Topics:**
     - Methods for updating embedded firmware remotely (bootloaders, OTA updates).
     - Ensuring robust firmware update mechanisms that protect against incomplete or corrupted updates.
   - **Development:**
     - Implement a bootloader that can facilitate firmware updates for the extension boards.
     - Design a simple protocol for firmware updates over UART, ensuring that the process can be initiated and validated by the Raspberry Pi.
     - Test the update mechanism to ensure it is reliable and can recover from failed update attempts.

---

This is the breakdown for **Embedded Software Task #1: Firmware Development for Serial Extension Boards**. Let me know if you’d like to proceed to the next task!


### **OS Team Task #1:**  
**Raspberry Pi OS Configuration and Optimization with Log System Management**

---

### **Description:**  
The OS Team is responsible for setting up, configuring, and optimizing the Raspbian (Raspberry Pi OS) environment to support the Central Controller (CC) application. This includes managing the boot process, enabling the Flutter app to run on startup, handling OTA updates, securing the OS, and managing the app's logging system. The log system logs events as JSON files and follows a structure of `/logfolder/year/month/day/logfile1.json`. The OS team must periodically gather and send logs to the server when the connection is available and clean up old logs to free up space.

---

### **Research & Development Works:**

#### 1. **Flutter App Auto-Startup on Boot**
   - **Research Topics:**
     - Techniques for automatically launching applications on Raspberry Pi startup.
     - Systemd services and startup scripts.
   - **Development:**
     - Configure the system to automatically launch the Flutter app on boot using systemd or init scripts.
     - Ensure the app runs in a kiosk mode, preventing user access to the desktop environment.
     - Test different boot scenarios (power cycle, reboot) to verify the Flutter app always launches without user intervention.

#### 2. **OTA (Over-The-Air) Update Mechanism for the Flutter App**
   - **Research Topics:**
     - Strategies for implementing OTA updates in Raspbian.
     - Safeguarding against failed or incomplete updates (rollback mechanisms, version control).
   - **Development:**
     - Implement a secure and reliable method for updating the Flutter app over the network using `rsync`, `scp`, or custom update scripts.
     - Design a rollback mechanism that reverts to a previous version in case of a failed update.
     - Test the update and rollback procedures to ensure reliability.

#### 3. **Securing the Raspberry Pi OS**
   - **Research Topics:**
     - Best practices for securing Raspberry Pi OS in production environments.
     - Methods for locking down the OS to prevent unauthorized access.
   - **Development:**
     - Harden the OS by disabling unused services and securing access (SSH, file permissions, etc.).
     - Configure a firewall (e.g., `ufw`) to block unnecessary network ports and services.
     - Set up secure SSH access (e.g., public key authentication, disabling root login).

#### 4. **File System Optimization and Management**
   - **Research Topics:**
     - Strategies for optimizing file system performance for SD cards.
     - Log rotation and data management techniques.
   - **Development:**
     - Implement log rotation to handle large amounts of log data and free up disk space.
     - Optimize read/write operations on the SD card to prevent wear.
     - Monitor and manage file system space, ensuring logs don’t cause the system to run out of storage.

#### 5. **Timekeeping with Battery Backup (RTC Setup)**
   - **Research Topics:**
     - Configuring RTC modules for timekeeping on Raspberry Pi.
     - Time synchronization strategies (NTP servers).
   - **Development:**
     - Configure the RTC to keep track of time during power-offs.
     - Set up time synchronization with NTP servers when the Raspberry Pi is online.
     - Ensure reliable timekeeping across reboots and offline scenarios.

#### 6. **Offline Mode and Local Storage Management**
   - **Research Topics:**
     - Designing OS environments to handle offline operations while maintaining data integrity.
     - Synchronization of data and logs when the system reconnects online.
   - **Development:**
     - Ensure the OS supports full offline mode, saving all data and logs to the local file system.
     - Create mechanisms to sync logs, configurations, and other data with the central server when the Pi reconnects to the internet.

#### 7. **Log System Management**
   - **Research Topics:**
     - Techniques for managing and storing log files in resource-limited environments.
     - Methods for transmitting logs to a remote server and cleaning up old logs.
   - **Development:**
     - Implement a process to periodically gather log files from the `/logfolder/year/month/day/logfile1.json` structure.
     - Design a secure and efficient method for sending these logs to a server when the device is connected to the internet.
     - Implement automated log cleanup to delete old logs after successful transmission or when storage space is low.
     - Test the logging system for performance, ensuring it works seamlessly during offline and online scenarios.

#### 8. **Performance Monitoring and Optimization**
   - **Research Topics:**
     - Tools for monitoring system performance (CPU, memory, network usage).
     - Strategies for optimizing resource usage in a Raspberry Pi environment.
   - **Development:**
     - Set up monitoring tools like `htop` or `sar` to track CPU, memory, and I/O usage.
     - Implement scripts that automatically monitor system health and log performance data.
     - Optimize the system for low resource consumption, ensuring the Flutter app runs smoothly.

#### 9. **Automated Backups and Data Recovery**
   - **Research Topics:**
     - Backup solutions for Raspberry Pi (local and cloud-based).
     - Disaster recovery processes for data loss or system corruption.
   - **Development:**
     - Implement automatic backups for important data, including logs and configuration files.
     - Explore options for cloud-based backups for redundancy.
     - Develop a recovery mechanism that can restore the system from backups in the event of corruption or failure.

#### 10. **OS Image Customization for Mass Deployment**
   - **Research Topics:**
     - Custom OS image creation for mass deployment of Raspberry Pi units.
     - Pre-configuring images with the Flutter app, services, and security measures.
   - **Development:**
     - Create a customized Raspbian OS image with all necessary configurations, apps, and services pre-installed.
     - Develop a cloning process to replicate this image across multiple Raspberry Pi units for quick deployment in production.

---

This is the updated breakdown for **OS Team Task #1: Raspberry Pi OS Configuration and Optimization with Log System Management**. Let me know if you'd like to proceed to the next team!



### **Backend Team Task #1:**  
**API for Device Activation**

---

### **Description:**  
The Backend Team is responsible for creating an API that allows each Raspberry Pi to activate itself upon the first connection. This process establishes a device identity on the server, allowing future communication between the Pi and the backend.

---

### **Research & Development Works:**

#### 1. **Device Activation Flow**
   - **Research Topics:**
     - Device registration and activation methods for IoT systems.
     - Secure token generation and validation for device activation.
   - **Development:**
     - Design an API endpoint for initial activation that accepts device details (e.g., serial number, device ID).
     - Implement token-based device registration that assigns a unique identity to each Raspberry Pi.
     - Secure the activation process using TLS/SSL to protect device and server communication.

#### 2. **Token Generation and Assignment**
   - **Research Topics:**
     - JWT (JSON Web Token) creation and best practices for secure API authentication.
   - **Development:**
     - Generate a JWT upon successful device activation.
     - Assign this token to the Raspberry Pi for subsequent API interactions, ensuring secure communication.
     - Implement expiration and renewal logic for tokens to ensure continued security.

#### 3. **Database Integration for Device Records**
   - **Research Topics:**
     - Storing device records (e.g., ID, activation date, status) in the backend database.
   - **Development:**
     - Add tables for tracking activated Raspberry Pi devices, including their statuses and metadata.
     - Ensure efficient querying and updating of device records as they activate and interact with the system.

---

### **Backend Team Task #2:**  
**User Sign-in and JWT Token Authentication**

---

### **Description:**  
The Backend Team must provide a secure sign-in API that allows users to authenticate themselves and obtain a JWT token. This token will be used by the Raspberry Pi and the Flutter app for all further API communication.

---

### **Research & Development Works:**

#### 1. **API for User Sign-in**
   - **Research Topics:**
     - Secure authentication flows (e.g., OAuth2, JWT-based auth).
   - **Development:**
     - Create a login API that validates user credentials (username, password) and generates a JWT token.
     - Integrate the sign-in API with the user database, ensuring secure storage of user credentials (e.g., using bcrypt for password hashing).
     - Set up appropriate error handling for failed logins (e.g., account lockout after multiple failed attempts).

#### 2. **JWT Token Generation and Validation**
   - **Research Topics:**
     - Best practices for JWT token creation, validation, and expiration.
   - **Development:**
     - Implement token issuance during sign-in, with expiration times and refresh mechanisms.
     - Securely store tokens on the Raspberry Pi for ongoing API use.
     - Build a token validation system to authorize future API calls from the Flutter app.

#### 3. **User Role Management and Access Control**
   - **Research Topics:**
     - Role-based access control (RBAC) for users (e.g., admin, regular user).
   - **Development:**
     - Define user roles in the backend and ensure API endpoints respect access restrictions based on roles.
     - Integrate role management into the JWT claims, ensuring the app can enforce different UI or functionality based on user roles.

---

### **Backend Team Task #3:**  
**Log Sync API**

---

### **Description:**  
The backend must provide an API that allows Raspberry Pi devices (Flutter app and OS team scripts) to periodically send logs. The backend will be responsible for storing these logs efficiently and making them accessible for analysis.

---

### **Research & Development Works:**

#### 1. **Log Sync API Design**
   - **Research Topics:**
     - Best practices for handling large log files or log streams in an IoT environment.
     - Strategies for receiving and storing JSON logs efficiently.
   - **Development:**
     - Design an API endpoint that accepts log files from Raspberry Pi devices. The logs will follow a structure such as `/logfolder/year/month/day/logfile1.json`.
     - Implement mechanisms for handling large batches of logs, ensuring the API can handle multiple devices syncing logs simultaneously.
     - Set up error handling for failed uploads, ensuring logs can be re-sent if necessary.

#### 2. **Log Storage and Database Design**
   - **Research Topics:**
     - Log storage solutions (e.g., time-series databases, file-based storage systems).
     - Compression techniques for log data to minimize storage footprint.
   - **Development:**
     - Implement a scalable storage solution for logs that supports efficient querying by time, device, and log type.
     - Build data retention policies (e.g., archiving, deleting old logs after a certain period).
     - Optimize the database for write-heavy operations since logs will be frequently uploaded from multiple devices.

#### 3. **Log Retrieval and Reporting**
   - **Research Topics:**
     - Querying and reporting tools for log analysis.
     - Dashboards or visualization tools for monitoring logs in real time.
   - **Development:**
     - Build APIs or interfaces to retrieve and visualize logs for system administrators or developers.
     - Ensure log access can be filtered by device, date, and event type for easy troubleshooting and analysis.
     - Explore integration with third-party log visualization platforms (e.g., ELK Stack, Grafana) for advanced analysis.

---

Let me know if you'd like to expand on any of these or move on to the next steps!



### **Flutter Team: Main Tasks Overview**

---

1. **Task #1: Flutter App Core Development**
   - Building the app that runs on the Raspberry Pi, including the UI and core functionalities.
   - Handling user account creation, zone and device management, and the control loop for checking device statuses and commands.
   - Ensure smooth and responsive performance on the Raspberry Pi’s limited resources.

2. **Task #2: GPIO and Serial Communication Integration**
   - Developing the logic to control devices through GPIO and serial communication with custom hardware extensions.
   - Manage inputs and outputs from the Raspberry Pi's GPIO pins and UART interface for connected devices.

3. **Task #3: Weekly Plan and Temperature Management**
   - Implementing the logic for scheduling device actions based on a weekly plan and temperature data.
   - Handling sensor data, evaluating time and conditions, and sending commands to devices accordingly.

4. **Task #4: User Interface (UI) Design and User Experience (UX)**
   - Creating a clean, intuitive UI for controlling zones, devices, and viewing status.
   - Implementing screens for adding devices, managing zones, and setting up weekly plans.
   
5. **Task #5: Local Data Management with SQLite**
   - Implementing local storage for zones, devices, and user settings using SQLite.
   - Ensuring data integrity and synchronization between UI actions and database changes.

6. **Task #6: Log System Integration**
   - Adding the functionality to log events and status changes in JSON format.
   - Ensure logs follow the structure `/logfolder/year/month/day/logfile1.json` and that logs are accessible for the OS team.

7. **Task #7: Authentication API Integration**
   - Connecting the app to the backend for initial device activation and user sign-in via JWT.
   - Ensuring proper handling of JWT tokens and secure communication with the backend server.

---

Let me know which task you'd like to start with, and I will provide the subtasks and details!


### **Flutter Task #1: Flutter App Core Development**

This task focuses on building the core architecture of the app running on the Raspberry Pi, ensuring smooth operation, responsive performance, and integration of essential features. 

---

#### **Subtask #1: Project Setup and Configuration**
   - **Description:**
     - Initial setup of the Flutter project tailored for Raspberry Pi, configuring it for use with the Pi’s hardware resources (e.g., touchscreen).
   - **Steps:**
     1. Set up the Flutter environment for Raspberry Pi, ensuring it supports ARM architecture.
     2. Configure project settings for optimal performance on Raspberry Pi hardware.
     3. Ensure that the app starts on boot in the Raspberry Pi OS.
     4. Set up hot reload or remote debugging tools for efficient development.

---

#### **Subtask #2: App Architecture Design**
   - **Description:**
     - Define the architectural structure of the app, ensuring it supports scalability and clean separation of concerns (e.g., controllers, services, UI).
   - **Steps:**
     1. Decide on state management solution (e.g., Provider, Riverpod, Bloc).
     2. Create service classes for handling device operations, GPIO/serial communication, data storage, and log management.
     3. Structure app with modular design: separate code into controllers, services, models, and UI components.
     4. Ensure a responsive design that fits the 7" touchscreen display.

---

### **Subtask #3: Control Loop Implementation**

---

**Description:**  
Develop the core control loop that runs every second to check device statuses, weekly plan schedules, temperatures, and trigger commands based on conditions. This loop will also monitor an emergency GPIO input pin, and if an alarm is triggered (e.g., fire), the system must immediately shut down all connected devices.

---

**Steps:**

1. **Implement Timer for Control Loop**
   - Set up a background service or periodic timer that runs the control loop every second.
   - Ensure the timer is lightweight and efficient for Raspberry Pi’s hardware.

2. **Query the SQLite Database**
   - Retrieve current zone configurations, device mappings, weekly plans, and sensor data from SQLite.
   - Ensure data is always up-to-date and reflect user changes immediately.

3. **Monitor Device Statuses and Sensor Data**
   - Continuously check device statuses via GPIO and serial communication.
   - Read temperature sensors from SPI to ensure accurate real-time data for decision-making.

4. **Evaluate Weekly Plan and Conditions**
   - Compare the current time and date with the weekly plan for each device.
   - Check temperature readings and other relevant data to determine whether a device needs to be turned on or off.
   - If conditions are met (e.g., certain temperatures reached, scheduled time), send appropriate GPIO/serial commands to control devices.

5. **Emergency Input Pin Monitoring**
   - Monitor the reserved GPIO input pin for emergency signals (e.g., fire alarms).
   - **Action on Trigger:**
     - If the alarm input is triggered, immediately override all other logic in the control loop.
     - Execute a shutdown sequence for all connected devices (e.g., heaters, coolers, gates, lights), sending commands via GPIO and serial communication.
     - Ensure that the system remains in this emergency state until manually reset or the alarm input is deactivated.

6. **Send Commands via GPIO and Serial**
   - Based on the conditions evaluated (weekly plan, sensor data, emergency input), send appropriate GPIO signals or UART commands to connected devices.
   - Ensure communication is reliable, and implement error handling in case of failed commands or connection issues.

7. **Log Events**
   - Log all events related to device control, such as device activation/deactivation, errors, and emergency shutdown triggers.
   - Ensure that these logs follow the standard JSON format (`/logfolder/year/month/day/logfile.json`), so they can be picked up by the OS team for further processing.

8. **Error Handling**
   - Include robust error handling to ensure the loop continues even if there are temporary communication or data retrieval failures.
   - Gracefully handle sensor or device communication failures by logging errors and attempting retries.

---

This updated subtask integrates the emergency input pin monitoring into the core control loop. Let me know if you need further details!

---

#### **Subtask #4: Zone and Device Management Logic**
   - **Description:**
     - Handle adding, updating, and removing zones and devices in the app, and mapping devices to GPIO pins or serial commands.
   - **Steps:**
     1. Develop UI screens for adding, editing, and deleting zones.
     2. Implement device addition logic, allowing users to assign devices to zones.
     3. Create a mapping system to link devices to GPIO pins or serial extension boards.
     4. Ensure changes made by users update the local SQLite database in real time.
     5. Build validation checks (e.g., ensure unique device names, prevent duplicate GPIO assignments).

---

#### **Subtask #5: Error Handling and Recovery**
   - **Description:**
     - Implement error handling and recovery for various potential issues (e.g., loss of GPIO communication, invalid data inputs, or SQLite errors).
   - **Steps:**
     1. Develop mechanisms for catching and logging errors related to device control, data retrieval, and system status checks.
     2. Implement fallback strategies in case of communication failure with devices.
     3. Notify users of system errors via UI, and ensure critical errors are recorded in the log system.

---

#### **Subtask #6: Offline Mode**
   - **Description:**
     - Ensure the app works fully offline once the initial user account setup is complete. The app should retain all functionality (zone management, device control, and scheduling) without a server connection.
   - **Steps:**
     1. Confirm that user data, zone settings, and device plans are all stored locally in SQLite.
     2. Ensure that API-dependent features like log syncing or OTA updates are deferred when offline.
     3. Develop methods to gracefully handle the absence of server communication without interrupting device control functionality.

---

#### **Subtask #7: Power Management and Start/Stop Procedures**
   - **Description:**
     - Manage how the app behaves during power-up, shutdown, or restarts, including ensuring correct restoration of device states after reboot.
   - **Steps:**
     1. Create a startup procedure that retrieves the previous device states from SQLite and applies them immediately when the app starts.
     2. Implement shutdown logic that safely saves the current state and stops any ongoing device commands.
     3. Work with the OS team to ensure the app starts automatically on Raspberry Pi boot.

---

### **Flutter Task #8: Setup Process Implementation**

---

**Description:**  
Develop and implement the initial setup process for the Raspberry Pi, ensuring that users can configure the device with essential settings and register it for activation via their client account. This process also includes establishing on-device accounts (Tech Support, Admin) and setting up the system's operating parameters.

---

**Steps:**

1. **Language Selection Screen**
   - Develop a screen that allows users to select their preferred language for the app.
   - Store the language preference locally and apply it to the entire UI.

2. **Timezone Selection Screen**
   - Implement a screen for timezone selection.
   - Ensure that the selected timezone is applied to date/time functionalities throughout the app.

3. **Date-Time Display Format Selection**
   - Provide options for users to choose between different date-time formats (e.g., 24-hour or 12-hour clock).
   - Implement logic to apply this setting across the app.

4. **Network Connection (Wi-Fi/Ethernet)**
   - Develop UI to manage Wi-Fi or Ethernet connection setup.
   - Integrate the process to search for available Wi-Fi networks, allowing users to enter credentials to connect.
   - Ensure error handling for failed connections and reconnection attempts.

5. **Device Registration**
   - Automatically gather necessary information about the Raspberry Pi (e.g., device ID, hardware details).
   - Send this information to the backend server via API for device registration.

6. **Client Sign-In (Cloud Account)**
   - Build a login screen for the user’s cloud account (client account).
   - Handle user authentication and retrieval of a JWT token upon successful login.
   - Include "create account" and "forgot password" options that interact with the backend.

7. **Subscription Status Check**
   - After sign-in, make an API call to retrieve the user's subscription status.
   - Apply any restrictions (e.g., limited zones/devices for free accounts) within the app based on the returned subscription status.

8. **Device Activation**
   - Upon successful registration and subscription check, implement the logic to activate the Raspberry Pi via an API call.
   - Ensure that the Pi’s activation status is stored locally and retrievable for future use.

9. **Tech Support Account Creation**
   - Guide the user through the creation of a Tech Support account, allowing for technical management of the Pi.
   - Store the account credentials locally and ensure proper access levels are enforced in the app.

10. **Admin Account Creation**
   - Develop a flow for creating an Admin account, which will have broader access to device settings and user management.
   - Allow the user to add additional standard accounts as needed during the setup.

11. **Theme Selection (Light/Dark/System)**
   - Provide users with an option to select between light, dark, or system themes.
   - Ensure that the theme choice is applied to the app's UI consistently.

12. **Welcome/Onboarding Screens**
   - Develop a welcome screen and provide a brief onboarding walkthrough that introduces users to the key features of the system (zones, devices, control options).

---

This subtask ensures a smooth, guided setup for the Raspberry Pi, covering all necessary steps from language selection to activation and account creation. Let me know if you'd like to break down any of these steps further!


