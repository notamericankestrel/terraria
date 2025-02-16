#!/bin/bash
cd /home/container

# Ensure log directory exists
mkdir -p /container/logs
LOG_FILE="/container/logs/latest.log"

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

#export DOTNET_ROOT=/usr/lib/dotnet/
printf "dotnet version: "
dotnet --version

# Replace Startup Variables
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo -e ":/home/container$ ${MODIFIED_STARTUP}"

# Start the Terraria server in a screen session and log output
screen -dmS terraria_server bash -c "${MODIFIED_STARTUP} | tee -a $LOG_FILE"

# Attach to the screen session to display output
exec screen -r terraria_server
