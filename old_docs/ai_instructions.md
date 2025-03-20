
### Common Instructions
- When I request a feature, do not edit code. First show me your plan, If I approve then edit code.
- Always check linting and analysys before tell me it is ready to test, to ensure its error free.
- Do not commit the changes until I say specificly so.
- Always check git status before starting a commit procedure.


### Project Specific Instructions
- This project meant to run on a custom Raspberry Pi4b Which I call it `Central Controller (CC)`. The only way to see/test code is preparing a release build. There is no run/debug.
- There is no way to view a console to read debug prints.
- Common way to investigate is displaying a temporary listview to the screen, for debug prints.
- The touchscreen is 800x480.
- The capabilities are 4 hardware buttons (GPIO), 8 digital inputs (GPIO), 8 digital outputs (GPIO), 4 analog inputs (SPI), a buzzer (GPIO), a RTC unit (I2C), and serial communication with extension boards with UART.

