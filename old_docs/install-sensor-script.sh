#!/bin/bash

set -e  # Exit immediately on error

# Create necessary directories if they don't exist
echo "Ensuring necessary directories exist..."
runuser -l pi -c "mkdir -p /home/pi/Heethings/CC"

# Download the sensor.zip file
echo "Downloading sensor.zip..."
wget -P /home/pi/Heethings/CC https://releases.api2.run/heethings/cc/sensor.zip || { echo "Failed to download sensor.zip"; exit 1; }
# Kill any running Python processes related to the sensor
echo "Killing Python processes..."
sudo pkill -f python || echo "No Python processes found to kill."

# Stop and disable the service if running
if systemctl is-active --quiet sensor_server.service; then
    echo "Stopping the running sensor_server.service..."
    sudo systemctl stop sensor_server.service || { echo "Failed to stop sensor_server.service"; exit 1; }
fi

# Check if the service unit file exists before disabling it
if [ -f "/etc/systemd/system/sensor_server.service" ]; then
    echo "Disabling the sensor_server.service..."
    sudo systemctl disable sensor_server.service || { echo "Failed to disable sensor_server.service"; exit 1; }
else
    echo "sensor_server.service does not exist, skipping disable step."
fi

# Remove the virtual environment if it exists
if [ -d "/home/pi/Heethings/CC/sensor/sensor_env" ]; then
    echo "Removing the virtual environment folder..."
    sudo rm -rf /home/pi/Heethings/CC/sensor/sensor_env || { echo "Failed to remove the virtual environment folder"; exit 1; }
fi

# Remove the old sensor folder if it exists
if [ -d "/home/pi/Heethings/CC/sensor" ]; then
    echo "Removing the old sensor folder..."
    sudo rm -rf /home/pi/Heethings/CC/sensor || { echo "Failed to remove the sensor folder"; exit 1; }
fi

# Unzip the updated files
echo "Extracting the updated sensor ZIP file..."
unzip -o /home/pi/Heethings/CC/sensor.zip -d /home/pi/Heethings/CC || { echo "Failed to extract the updated ZIP file"; exit 1; }

# Recreate the virtual environment
cd /home/pi/Heethings/CC/sensor || { echo "Sensor folder not found"; exit 1; }
echo "Creating a new virtual environment..."
python3 -m venv --without-pip sensor_env || { echo "Failed to create the virtual environment"; exit 1; }

echo "Activating the virtual environment..."
source sensor_env/bin/activate || { echo "Failed to activate the virtual environment"; exit 1; }

echo "Installing pip..."
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py || { echo "Failed to download get-pip.py"; exit 1; }
python get-pip.py || { echo "Failed to install pip"; exit 1; }

echo "Installing dependencies..."
pip install flask spidev || { echo "Failed to install dependencies"; exit 1; }

# Deactivate virtual environment
deactivate || echo "Virtual environment deactivation failed. Continuing..."

# Create the service file
echo "Creating the service file..."
SERVICE_FILE="/etc/systemd/system/sensor_server.service"
sudo bash -c "cat > $SERVICE_FILE" <<EOL
[Unit]
Description=Sensor Server
After=network.target

[Service]
ExecStart=/home/pi/Heethings/CC/sensor/sensor_env/bin/python /home/pi/Heethings/CC/sensor/script/read-sensor-data.py
WorkingDirectory=/home/pi/Heethings/CC/sensor
StandardOutput=inherit
StandardError=inherit
Restart=always
User=pi

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd configuration, enable and start the service
echo "Reloading systemd configuration..."
sudo systemctl daemon-reload || { echo "Failed to reload systemd configuration"; exit 1; }

echo "Enabling the sensor_server.service..."
sudo systemctl enable sensor_server.service || { echo "Failed to enable sensor_server.service"; exit 1; }

echo "Starting the sensor_server.service..."
sudo systemctl start sensor_server.service || { echo "Failed to start sensor_server.service"; exit 1; }

echo "Clean up"
sudo rm -rf /home/pi/Heethings/CC/__MACOSX/
sudo rm -rf /home/pi/Heethings/CC/sensor.zip

# Optional: Reboot the system
# echo "Rebooting the system now..."
# sudo reboot now
