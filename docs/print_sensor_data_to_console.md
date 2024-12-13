import spidev
import time
import math

spi = spidev.SpiDev()
spi.open(0, 0) # Bus 0, Device 0
spi.mode = 0b00  
spi.max_speed_hz = 3500000

# Read SPI Sensor input 0 to 7 for MCP3004

def ReadInput(Sensor):
adc = spi.xfer2([1, (4 + Sensor) << 4, 0])
data = ((adc[1] & 3) << 8) + adc[2]
return data

# Convert Voltage to Resistance

def VoltToOhm(V):
Rd = 10000
Rd_effective = (Rd _ 16800.0) / (Rd + 16800.0)
Ohm = (3.3 - V) / V _ Rd_effective
return Ohm

# Convert resistance to temperature

def OhmToCelsius(ohms):
A = 0.00335401643468053
B = 0.0002744032
C = 0.000003666944
D = 0.0000001375492
r = math.log(ohms / 10000.0)
temp = 1.0 / (A + B _ r + C _ r ** 2 + D \* r ** 3)
temp = temp - 273.15
return temp

while True:
for i in range(1, 8):
RawValue = ReadInput(i) # Read the raw input from the chip
percent = (RawValue / 10.23) # Convert to a percentage
Voltage = (percent / 100.0) \* 3.3 # Convert % to a 0 to 3.3 Volts

        if Voltage > 0:  # Skip If 0 to avoid divide by zero error
            Ohms = VoltToOhm(Voltage)  # Convert Voltage to resistance
            DGC = OhmToCelsius(Ohms)  # Convert to temp in Celsius
        else:
            Ohms = 0.0
            DGC = -50.0

        # Format values to 2 decimal places
        PCTStr = ", PCT={0:.2f}".format(percent) + "%"
        VoltsStr = ", Volts={0:.2f}".format(Voltage) + "V"
        OhmsStr = ", Ohms={0:.2f}".format(Ohms) + " ohms"
        DGCStr = ", Temperature={0:.2f}".format(DGC) + "C"

        print("Sensor No " + str(i), "Raw=" + str(RawValue),)

    time.sleep(2)
