# Backrest

Restic is a nice way of doing sequential backup with deduplication and encryption. Backrest is a web gui for it.

I have written a few scripts to simplify setup and then ongoing actions.


## Installation

Just use the compose file. You have to mount the directories to be backed up and if going to save a local copy of the backup then you need a bind mount for that too.


## Add New Container

Hopefully when creating the new service I'll have used the new-container script, alias dn. It will create template files.

1. Add any files or folders from /data/service to .resticignore as required.
2. Add any actions that need to happen to prepare-backup-sh

The aim is that Backrest will backup everything in ~/containers and ~/data unless told to exclude it by .resticignore


## Details of Setup and Helper Scripts

### SSH

I am connecting to a home server using SFTP as a backup destination. I already have that server set up in my ssh configuration. There is a helper script to create a new key and add it to that server, and then to make a local copy of the SSH config for mounting into the container.
If you don't plan to use SSH / SFTP then you don't need any of this and don't need to mount the ssh folder.


## Hooks

Hooks are processes that run as part of the backup or repo in response to an event. I'm using:
 - CONDITION_SNAPSHOT_SUCCESS: when backup is successful to push a status to Uptime Kuma and take tailscale down.
 - CONDITION_ANY_ERROR: to push a failure message to Uptime Kuma.
 - CONDITION_SNAPSHOT_START: to bring up Tailscale and run pre backup actions.

The hooks need to communicate with the host and so they do it like this:
 - A named pipe (FIFO special file) is created on the host and mounted to container.
 - Container writes messages to pipe.
 - A script running on host reads messages and runs commands / scripts in response to specific messages.

There's a specific setup script called *create-backrest-pipe.sh* which does the setup and starts the monitoring script running, including adding it to crontab.



## Exclusions

Restic allows lots of different ways of excluding files from backup. Here I have settled on a /resticignore file in each data directory. This is not any official ignore file, I've just chosen to call it that as it functions like a gitignore. There is a script called *build-ignore-file.sh* which should be called at the start of the backup. It iterates through all the .resticignore files, prepending data/$servicename to make sure they are specific to that folder, and creating a unified ignore file.

You need to add a flag to the backup:
`--exclude-file=/path/to/ignorefile` and since it's in the backup path I've not added a specific mount for it.


## Pre Backup Actions

Some containers need actions to take place before backup. For example, stopping a service or dumping a database. (A text dump of database will be slower but better for recreating the tables and much better for deduplication.) There's another script called *pre-backup-actions.sh* called by a hook. It looks in every data/service directory for prepare-backup.sh and will run it if it exists.
