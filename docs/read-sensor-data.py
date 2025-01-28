#!/usr/bin/env python3
from flask import Flask, jsonify
import spidev
import time
import math
from statistics import mean

app = Flask(__name__)

spi = spidev.SpiDev()
spi.open(0, 0)  # Bus 0, Device 0
spi.mode = 0b00
spi.max_speed_hz = 3500000

def ReadInput(Sensor):
    try:
        adc = spi.xfer2([1, (4 + Sensor) << 4, 0])
        data = ((adc[1] & 3) << 8) + adc[2]
        return data
    except Exception as e:
        print(f"Error reading sensor {Sensor}: {str(e)}")
        return None

def get_stable_reading(sensor):
    # Take 100 readings as quickly as possible
    readings = [ReadInput(sensor) for _ in range(100)]
    # Filter out any None values (from errors)
    valid_readings = [r for r in readings if r is not None]
    
    if not valid_readings:
        return None
        
    # Return the average of all valid readings
    return int(mean(valid_readings))

@app.route('/sensors', methods=['GET'])
def get_sensor_data():
    data = []
    for i in range(1, 8):
        raw_value = get_stable_reading(i)
        if raw_value is not None:
            data.append({
                'sensor': i,
                'raw_value': raw_value
            })
    
    response = {
        'timestamp': int(time.time()),
        'sensors': data
    }
    return jsonify(response)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
