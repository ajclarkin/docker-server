# Opencloud

I've had a bit of a play around installing this as an alternative to Nextcloud. I could not get collabora to work with my linuxserver.io installation of nextcloud and I was not convinced that I set Nextcloud AIO up correctly (and it was huge). I like the idea of Opencloud as it is (also) European, reportedly faster than Nextcloud, hopefully lightweight, and straightforward to backup.

## Installation & Configuration

It's a bit different from the usual docker containers. They provide a modular set of compose files and a .env file which is used for the configuration:

 1. Clone the repo into local directory. I also renamed it to opencloud.
 2. Copy .env.example to .env and this becomes the main setup file.
 3. Edit the settings required - I'll upload different versions here to demonstrate.
 4. Set COMPOSE_FILE in .env to list the various compose files needed for the components required
 5. Docker compose up -d


## Networking

In Nginx Proxy Manager activate websocket support and don't block common exploits. SSL is required.

#### Opencloud Only

The standard docker compose specifies opencloud-net as the network. If you run with this rather than specifying your usual network then you need to connect NPM to this container so that it can route traffic accordingly. The functioning network will be opencloud_opencloud-net (and you can check with `docker network ls`).

`docker network connect opencloud_opencloud-net nginx-proxy-manager`

I've also checked and you can do the usual docker manouvre to connect this container to our own docker network by specifying our network instead of opencloud-net and then changing the network session at the bottom to whatever is in all the other container compose files.
