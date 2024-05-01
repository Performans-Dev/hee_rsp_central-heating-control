## Screens
- home  `HomeScreen`: Zone List
- zone `ZoneScreen`: Zone Detail / device list
- settings `SettingsScreen`: Device/Zone Settings, AppSettings, Functions
    - zone_device_settings `ZoneAndDeviceSettingsScreen`
        - zone_settings `ZoneSettingsScreen`: zone list
            - zone `ZoneEditScreen`: edit-remove zone
            - add_zone `AddNewZoneScreen`: add new zone
        - device_settings `DeviceSettingsScreen`: device list
            - device `DeviceEditScreen`: edit-remove device
            - add_device `AddNewDeviceScreen`: add new device
        - sensor_settings `SensorSettingsScreen`: sensor list
            - sensor `SensorEditScreen`: edit-remove sensor
            - add_sensor `AddNewSensorScreen`: add new sensor
    - app_settings `AppSettingsScreen`
        - Language [Dropdown]
        - Timezone/DateLocale
            - timezone_screen `TimezoneSettingsScreen`
        - Theme [Dropdown]
        - ScreenSaver Duration [Dropdown]
        - Connection [Dropdown+Detail]
            - ethernet `EthernetSettingsScreen`: static (ip) / DHPC
            - wifi `WiFiSettingsScreen`: ssid, password
        - User Management
            - users `UserManagementScreen`: list users
                - user `UserScreen`: edit-delete user
            - add_user `AddUserScreen`: add new user
        - Check Updates -> checks for app updates
        - Developer Tools `DeveloperScreen`: logs
        - Hardware Config `HardwareConfigScreen`: expansion slot settings
        - About `AboutScreen`: info about app and heethings
    - functions `FunctionsScreen`: list F1-F2-F3-F4
        - function `FunctionScreen`: clicked function editor wizard [target]->[action]->[trigger]->[save]
            - function_target `FunctionTargetScreen`: picks zone/devices
            - function_action `FunctionActionScreen`: picks action to be done to selected zones/devices
            - function_trigger `FunctionTriggerScreen`: picks hardware button
            - function_summary `FunctionSummaryScreen`: displays target-action-trigger and add a name to it.
    - weekly_plan `WeeklyPlanScreen`: displays tableview
        - weekly_plan_edit `WeeklyPlanEditScreen`: displays [target]-[action]-[start-stop] of picked [day]
- pin `PinScreen`: displays userlist-numeric keypad
- splash `SplashScreen`: display when busy state
- screen_saver `ScreenSaverScreen`: display when idle, get.back to pin screen when touched
- initial_setup_language `InitialSetupLanguageScreen`: ask language
- initial_setup_timezone `InitialSetupTimezoneScreen`: asks for timezone / datelocale
- activation_info `ActivationInformationScreen`: informs  that user is about to activate the product
- initial_setup_connection  `InitialSetupConnectionScreen`: asks connection options: eth-wifi, static-ip/dhcp - wifi-ssid,pass, test connection
- signin `SigninScreen`: allow user to sign in with heethings credentials
    - create_account `CreateAccountScreen`: allow user to create a heethings account
        - otp `OtpScreen`: allow user to enter email validation code
    - forgot_password `ForgotPasswordScreen`: allow user to reset password
        - add_admin `AddAdminUserScreen`: allow user to create an admin user with name and pin
- error `ErrorScreen`: show when an error (type=danger) occurs

        
        
## Alerts&Dialogs
- ConfirmDialog
- AlertDialog
- Snackbar
    - Success
    - Info: optional action
    - Warning: optional action
    - Error: persistent, optional retry action
- ProgressDialog

## Components
- AppScaffold
- HardwareButtonLayoutStack
- NumericKeypad: Pin/Otp
- HorizontalListViewForUserSelect
- HorizontalListViewForDeviceSelect
- HorizontalListViewForSensorSelect
- HorizontalListViewForZoneSelect

## Widgets
- CustomTextInputWidget
- CustomDropdownMenuWidget
- HardwareButtonWidget
- ActionButtonWidget: elevated, outlined, text
- CustomSwitchWidget: theme is Dark Mode
- WeeklyPlanItemWidget
- ColorPickerWidget
- IconPickerWidget
- OnOffLevelToggleWidget
- CelciusPickerWidget

## Controllers
- `AppController`: flags, app settings, hardware settings, language, locale, theme, logs
- `DataController`: zones, devices, sensors, users, weekly plan, actions, functions.
- `MqttController`: connect, subscribe, publish, applyReceivedMessage

## Providers
- `AppProvider`
    - `fetchAppSettings`
    - `fetchHardwareSettings`
    - `registerHardware`
    - `activateHardware`
    - `checkHardware`
    - `userSignin`
    - `userForgotPassword`
    - `userCreateAccount`
    - `userValidateAccount`
    - `fetchMqttInfo`
    - `addLog`
    - `fetchTimezoneList`
    - `fetchLanguageList`
    - `fetchDateLocaleList`
    - `checkUpdates`

## Models
- `Account`: heethins user, email,pass
- `AccountSubscriptionType`: free, paid
- `SigninRequest`
- `CreateAccountRequest`
- `ValidateAccountRequest`
- `ForgotPasswordRequest`
- `ValidateOtpRequest`
- `ActivationRequest`
- `RegisterHardwareRequest`
- `User`: app user, name,pin,isAdmin
- `UserLoginRequest`
- `MqttSettings`: host,port,user,pass,topicPrefix
- `GenericResponse`: Api response
- `PlatformDefinition`: Hardware info
- `TimezoneDefinition`
- `LanguageDefinition`
- `DateLocaleDefinition`
- `ZoneDefinition`
- `HeaterDevice`
- `SensorDevice`
- `HeaterDeviceType`: heater level, connection
- `SensorDeviceType`: contains min-max
- `ConnectionType`: relay, eth
- `WeeklyPlanItem`
- `HardwareButton`
- `RelayDefinition`


## Enums
- `HardwareButtonLocation`: l0,l1,l2,l3,r0,r1,r2,r3
- `ConnectionState`: connected, notConnected
- `JobState`: idle, requested, success, error
