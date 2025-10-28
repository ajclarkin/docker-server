#!/bin/bash


# Find script directory - script is in a subdirectory so make this reliable
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/../.."

# Source the .env file assumed to be at project root
[ -f "$PROJECT_ROOT/.env" ] && . "$PROJECT_ROOT/.env"


# Create the pipe that will be used
mkfifo ${CONTAINER_DIR}/backrest-pipe

# Start the watcher script
nohup ${CONTAINER_DIR}/scripts/actions/backrest-trigger.sh &

# Add the watcher script to crontab so that it survives reboots
(crontab -l ; echo "@reboot ${CONTAINER_DIR}/scripts/actions/backrest-trigger.sh") | crontab -


# We can check to see if the script is running with:
# 	ps aux | grep backrest-trigger.sh
# And use kill <pid> to kill it if required.
#
# Now echo "start-tailscale" > ./backrest-pipe will start tailscale
