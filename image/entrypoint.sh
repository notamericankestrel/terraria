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

# Start the Terraria server, log output, and send it to both file & console
exec ${MODIFIED_STARTUP} 2>&1 | tee -a "$LOG_FILE"
