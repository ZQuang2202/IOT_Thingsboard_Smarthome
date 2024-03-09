# Introduction

# PREREQUISITES 
To implement the project, you need to install several platforms and software. Below are the required installations:
- Install WSL (Windows Subsystem for Linux), Ubuntu, and Docker Desktop.
  - [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install)
  - [Ubuntu](https://ubuntu.com/download/desktop)
  - [Docker desktop](https://docs.docker.com/desktop/install/windows-install/)

- Install Mosquitto ( bao gồm gói Mosquitto broker, mosquitto_pub, mosquitto_sub,....): 
  - https://mosquitto.org/download/
- Install Thingsboard API and prerequisite software:
  + [IOT Thingsboard gateway](https://thingsboard.io/docs/iot-gateway/installation/)
  + [Thingsboard Edge](https://thingsboard.io/docs/user-guide/install/edge/installation-options/)
  + [Thingsboard Cloud/Thingsboard CE](https://thingsboard.io/docs/user-guide/install/installation-options/)

# STRUCTURE
## Mosquitto
  + default.conf: Configuration file for Mosquitto broker.
  + password.txt:  File initializing usernames and passwords.
## IOT Thingsboard-gateway
  + mqtt.json:  Configuration file for the MQTT CONNECTOR (host, port, authentication method,...)
  + tb-gateway.yaml:  Configuration file for the IOT gateway (broker, connection to Thingsboard CE/Edge)

## Thingsboard Edge
  + docker-compose.yml:  Configuration file for installing ThingsBoard Edge.

## Weather Monitor
 + data.sh:  Script to create virtual weather data
 + weather_monitor.json: Dashboard configuration file for displaying data on Thingsboard Weather Monitor
 + root_rule_chain.json:  Rule chain file used for Weather Monitor

## Wind turbine control 
  + tutorial_of_rpc_call_request.json: Rule Chain configuration file used on Edge.
  + tutorial_of_rpc_call_request (cloud): Rule Chain configuration file used on Cloud.
  + wind_turbine_dashboard.json:  Dashboard configuration file for displaying data.
  + WindDirectionEmulator.js:  File for uploading data to virtual wind direction measurement device.
  + RotatingSystemEmulator.js:  File using RPC requests to send control signals to virtual turbine rotation device.

# USAGE
## Configure Mosquitto
Configure Mosquitto by setting the host broker address to localhost with port 1883. Use password file authentication method. Create a password file with the following users:
```bash
user1: 1234
user2: 12345
```
For details, please check this [guide](https://mosquitto.org/documentation/authentication-methods/).

Configure Mosquitto broker with password file authentication method and listener on port 1883. Place this file at /etc/mosquitto/conf.d (Ubuntu) or Mosquitto folder (Windows).
```
listener 1883
allow_anonymous false
password_file /etc/mosquitto/password.txt
```

## IOT thingsboard gateway
Configure parameters for Mosquitto broker, topic, payload in mqtt.json and tb-gateway.yaml. Place these two files in /etc/thingsboard-gateway/conf/

## Cấu hình Thingsboard Edge
Follow the installation steps as per the guide at Thingsboard Edge Installation. Open the docker-compose.yml file and configure:
```
    ports:
      - "18080:8080"
      - "11883:1883"
      - "15683-15688:5683-5688/udp"
```
Replace CLOUD_ROUTING_KEY, CLOUD_ROUTING_SECRET, and CLOUD_RPC_HOST with the system parameters. Check the logging status of the edge with the command:
```
docker compose logs -f mytbedge
```

## Weather Monitor
1. Download the dashboard and rule chain to Thingsboard Cloud.
2. Assign the dashboard and rule chain to Edge in the Edge Instances section.
3. Run Mosquitto broker, Thingsboard gateway, and Thingsboard Edge.
4. Open 4 Ubuntu tabs and run the respective software on each tab.
5. Navigate to /etc/mosquitto/conf.d and run the Mosquitto broker with the command:
```bash
mosquitto -c default.conf 
```
Restart thingsboard gateway
```bash
sudo systemctl restart thingsboard-gateway.service
```
After running the Thingsboard gateway, observe the logging messages on the Ubuntu tab running Mosquitto broker.
Restart Thingsboard Edge with the command:
```bash
sudo systemctl restart tb-edge.service
```
Run the virtual data creation script:
``` bash
bash data.sh
```
After running the virtual data script, the simulated weather data will be displayed on the Ubuntu screen, indicating a successful connection. Check the logging status through Mosquitto broker and the data displayed on the Edge and Cloud dashboards.

## Wind Turbine control 
Install ThingsBoard Edge as per the above instructions.
Import the Dashboard and Rule Chain files to ThingsBoard Cloud and assign them to Edge Instances. Set the Rule Chain file name to "rule chain root".
Create 2 Devices:
WindDirection: Virtual wind direction sensor providing wind direction in the range of 0-360 degrees (code in WindDirectionEmulator.js).
Wind turbine: Virtual wind turbine control device (code in RotatingSystemEmulator.js).
Download the NodeJs version compatible with your computer from Node.js Download.
Open Command Prompt and navigate to the directory where the 2 JavaScript files are stored.
Run the following commands:
```bash
cd $path_to_downloaded_above_two_file
node WindDirectionEmulator
node RotatingSystemEmulator
```
Open the DashBoard on Edge and Cloud to monitor the results.