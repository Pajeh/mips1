import serial
import time

print "Opening Serial Port...."
ser = serial.Serial (0,115200)
ser.close()
ser.open()
print "port is open" if ser.isOpen() else "port is closed"
time.sleep(2)

datei = open("../sim/build/counter.txt", 'r')

for x in range (0, 65):
  inp0 = datei.read(8)
  ser.write(inp0.decode("hex"))
  print inp0
  datei.read(1)
  time.sleep(1)

datei.close();
