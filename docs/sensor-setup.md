## First create the Heethings folder if it doesn't exist.Then create the CC folder in the Heethings folder.

## Download the sensor.zip file to the CC folder:

- wget -P /home/pi/Heethings/CC releases.api2.run/heethings/cc/sensor.zip
##### This command downloads the `sensor.zip` file from the provided URL and saves it to the `/home/pi/Heethings/CC` directory.

## Then go to the Heethings folder and download the install-sensor-script.sh file:
- wget -P /home/pi/Heethings releases.api2.run/heethings/cc/install-sensor-script.sh
##### This command downloads the `install-sensor-script.sh` file and saves it to the `/home/pi/Heethings` directory for future execution.

## Run the installation script:
- sudo chmod +x install-sensor-script.sh (if it is not executable, run this command.)
- sudo ./install-sensor-script.sh