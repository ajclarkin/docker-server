#!/bin/bash

# Some services need actions before backup, like exporting a database.
# This script will cycle through each service looking for a prepare-backup.sh script.

DATA_ROOT=~/data

for SERVICE in $(ls "$DATA_ROOT"); do
    DATA_DIR="$DATA_ROOT/$SERVICE"
    if [ -x "$DATA_DIR/prepare-backup.sh" ]; then
	    (cd "$DATA_DIR" && ./prepare-backup.sh)
    fi
done
 
