# Backrest (Restic)

This solution uses [Backrest](https://github.com/hirosiit/backrest) as a web interface and orchestrator for [Restic](https://restic.net/) backups. It supports encrypted, deduplicated backups of Docker volumes and host directories, with custom scripts automating setup, notifications, and host integration.

## Core Features

- Encrypted, incremental backups
- Flexible exclusion via ignore files
- Automated pre-backup actions per service
- Secure remote backups over SFTP with helper scripts
- Custom hooks for network control and status notifications

***

## Installation \& Setup

1. **Clone Repo and Place Files**
Put your `docker-compose.yml`, `.env`, and this README in your chosen project directory.
2. **Mount Data and SSH Config**
    - Bind mount all directories you want backed up in the compose file. They will appear in backrest under /userdata
    - For remote SFTP backups, mount your host SSH config and keys into the Backrest container. See guide below to set this up (`configure-ssh.sh`)
3. **Initialize Host Integration**
    - Run `create-backrest-pipe.sh` on the host.
    - This script creates the FIFO pipe (`backrest-pipe`) and starts the monitoring script (ensure it's persistent with systemd or crontab).

***

## Adding/Configuring Containers

- Use the `new-container` script to scaffold new service templates.
  - This will create containers/new-service with compose.yaml and .env, and data/new-service with .resticignore and prepare-backup.sh
- Mount their data directories into Backrest using Docker Compose bind mounts, or preferably just mount containers/ and data/ and ensure the .resticignore files exclude appropriately.

***

## Exclusions: Ignore File Management

Restic allows file and pattern exclusions using an ignore file similar to `.gitignore`.

**How to use:**

1. **Create a `.resticignore` file** in each data/service directory, listing files or patterns to exclude.
2. **Run `build-ignore-file.sh`:** - this is run automatically at the beginning of each backup
    - Scans all `.resticignore` files.
    - Prepends service folder names to paths for clarity/specificity.
    - Merges everything into a single ignore file for your backup job.
3. **Reference the ignore file** in Backrest’s backup flags:

```
--exclude-file=/path/to/unified_ignorefile.txt
```


*No special mount is needed for the ignore file—it should reside in the backup path.*

***

## Pre-Backup Actions

Some services need setup before backup (e.g., DB dump, service pause).

**How to use:**

1. **Place a `prepare-backup.sh` script** in any service directory needing pre-backup steps.
2. **Let Hooks Manage Execution:**
    - Backrest’s pre-backup hook runs the main `pre-backup-actions.sh` script.
    - This scans each mounted directory and runs any `prepare-backup.sh` script it finds.
*For databases, prefer text dumps for backup (helps deduplication and clean restores).*

***

## SSH Setup for SFTP Remote Backups

To back up to a remote SFTP server:

1. **Use the provided helper script:**
    - Creates a new SSH key pair.
    - Adds the public key to your backup destination.
    - Copies your SSH config \& keys to a local folder for mounting into the Backrest container.
2. **Mount your SSH config and keys:**
    - Add a bind mount to your `docker-compose.yml` so the container has access.

*Skip this step and mount if you are not using SFTP for remote storage.*

***

## Hooks \& Host Scripts

Hooks automate networking and notifications at key backup/maintenance lifecycle stages.

**How it works:**

- Backrest writes commands to `/backrest-pipe` (in container)
- Host script monitors the pipe and runs:
    - `start-tailscale` → Enables secure networking
    - `stop-tailscale` → Disables networking
    - `pre-backups` → Runs pre-backup actions script
    - Curl notifications → Sends backup status externally to Uptime-Kuma

**Hook summary table:**


| Condition | Hook Action |
| :-- | :-- |
| SNAPSHOT_START | Start Tailscale, run pre-backup actions |
| SNAPSHOT_END | Notify success, stop Tailscale |
| ANY_ERROR | Notify failure, stop Tailscale |
| PRUNE/CHECK/START | Start Tailscale |
| PRUNE/CHECK/SUCCESS | Stop Tailscale |

*Hook errors are ignored (`ON_ERROR_IGNORE`)—ensure command safety.*

***


## Quick Tips

- Always update `.resticignore` to exclude unwanted files.
- Ensure pre-backup scripts are executable and tested for each service.
- Keep monitoring script running (systemd/crontab).
- For database containers: backup text dumps for optimal deduplication.
- Secure pipe and SSH keys with strict permissions.


