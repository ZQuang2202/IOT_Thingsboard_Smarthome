#!/bin/bash

while true; do
  # generate random data
  temp=$(( ( RANDOM % 70 )  + 10 ))
  hum=$(( ( RANDOM % 70 )  + 10 ))
  light=$(( ( RANDOM % 2 ) + 0 ))
  wind=$(( ( RANDOM % 360 )  + 0 ))
  windv=$(( ( RANDOM % 20 )  + 0 ))
  rain=$(( ( RANDOM % 20 )  + 0 ))
  air=$(( ( RANDOM % 400 )  + 0 ))
  press=$(( ( RANDOM % 5 )  + 10 ))
  # print to screeen the state of sending data and data
  echo "Sending data ... "
  echo "Temperature" $temp "Celcius"
  echo "Humidity" $hum "%"
  echo "Light" $light
  echo "Wind direction" $wind "degree"
  echo "Rain height" $rain "mm"
  echo "Air Quality" $air "AQI"
  echo "Pressure" $press "kPa"
  echo "Wind Velocity" $windv "km/h"
  echo -e "\n"
  
  # Send data to broker using mosquitto_pub
  mosquitto_pub -h 127.0.0.1 -p 1883 -u user1 -P 1234 -t "/sensor/data" -m "{\"serialNumber\":\"Virutal Device\", \"sensorType\":\"Thermometer\",\"sensorModel\":\"T1000\", \"temp\":$temp, \"hum\":$hum, \"light\":$light, \"wind\":$wind, \"rain\":$rain, \"air\":$air, \"press\":$press, \"windv\":$windv}"
  sleep 2   #pause 2 seconds 
done
