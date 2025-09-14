# Nextcloud

This is an installation using the LinuxServer image but with additional config for MariaDB rather than the default SQLite. It also uses a `.env` file to store secrets for the database.

Note that on Oracle the default user is opc and so commands need to be run accordingly: `sudo -u opc`


## Data Directories
This uses bind mounts in a subdirectory of home. This is for ease of backup.


## Updating Image
Take the containers down, then (remember to run as opc but omitted here for simplicity):
  - docker compose pull
  - docker compose up
    - Now read the notes as it comes up - this is why we don't do it detached. There might be actions required.
    - Complete any required actions. If you need to run `occ`  then `docker exec -it nextcloud bash` and run `occ` directly from the prompt, without any other path.
  - Once running normally take the containers back down so that we can start detatched: ctrl-c
  - docker compose up -d

    
