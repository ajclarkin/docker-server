#!/bin/bash

# Use this to create a new key to connect to SSH server. Here I already have credentials to connect as andrew@sunart.

# Find script directory - script is in a subdirectory so make this reliable
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/../.."

# Source the .env file assumed to be at project root
[ -f "$PROJECT_ROOT/.env" ] && . "$PROJECT_ROOT/.env"


mkdir -p ${DATA_DIR}/ssh
ssh-keygen -t ed25519 -f ${DATA_DIR}/ssh/id_rsa -C "backrest-backup-key"

# # Replace your-username and example.com with your remote server's details
ssh-copy-id -i ${DATA_DIR}/ssh/id_rsa.pub andrew@sunart

# Create the config file
cat > ${DATA_DIR}/ssh/config << EOF
Host sunart
  HostName 10.0.0.54
  User andrew
  IdentityFile /root/.ssh/id_rsa
  Port 22
EOF

# Add the server's fingerprint to known_hosts
# ssh-keyscan -H example.com >> ./backrest/ssh/known_hosts


chmod 700 ${DATA_DIR}/ssh
chmod 600 ${DATA_DIR}/ssh/*
