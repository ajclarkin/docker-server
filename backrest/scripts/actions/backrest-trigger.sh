#!/bin/bash

# This script allows the container to send commands to the host.
#
# Need to create the backrest-pipe using mkfifo and then this script monitors it for content.
# Actions to take are pre-defined.


# Find script directory - script is in a subdirectory so make this reliable
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/../.."

# Source the .env file assumed to be at project root
[ -f "$PROJECT_ROOT/.env" ] && . "$PROJECT_ROOT/.env"



while true; do
  while read line; do
    if [[ "$line" == "start-tailscale" ]]; then
      sudo tailscale up
    fi

    if [[ "$line" == "stop-tailscale" ]]; then
      sudo tailscale down
    fi

    if [[ "$line" == "pre-backups" ]]; then
      "${SCRIPT_DIR}/build-ignorefile.sh"
      "${SCRIPT_DIR}/pre-backup-actions.sh"
    fi
  done < "${CONTAINER_DIR}/backrest-pipe"
done

