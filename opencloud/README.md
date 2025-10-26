# Opencloud

I've had a bit of a play around installing this as an alternative to Nextcloud. I could not get collabora to work with my linuxserver.io installation of nextcloud and I was not convinced that I set Nextcloud AIO up correctly (and it was huge). I like the idea of Opencloud as it is (also) European, reportedly faster than Nextcloud, hopefully lightweight, and straightforward to backup.

## Installation & Configuration

It's a bit different from the usual docker containers. They provide a modular set of compose files and a .env file which is used for the configuration:

 1. Clone the repo into local directory. I also renamed it to opencloud.
 2. Copy .env.example to .env and this becomes the main setup file.
 3. Edit the settings required - I'll upload different versions here to demonstrate.
 4. Set COMPOSE_FILE in .env to list the various compose files needed for the components required
 5. Docker compose up -d


### Relevant Links

I'll put these here for ease. The compose guide explains how the modular setup works but is written around a system that is not using a reverse proxy. Use it for configuring the compose stack through .env itself. The external proxy guide explains how to set up a reverse proxy and we *do not* need to use this for NPM, but it does clarify what to do to have Collabora working.


- [Opencloud with Docker Compose](https://github.com/opencloud-eu/opencloud-compose)
- [Opencloud behind Reverse Proxy](https://docs.opencloud.eu/docs/admin/getting-started/container/docker-compose/external-proxy)


## Networking

In Nginx Proxy Manager activate websocket support and don't block common exploits. SSL is required.

#### Opencloud Only

The standard docker compose specifies opencloud-net as the network. If you run with this rather than specifying your usual network then you need to connect NPM to this container so that it can route traffic accordingly. The functioning network will be opencloud_opencloud-net (and you can check with `docker network ls`).

Make sure the bind mounts for the local data/ config/ and app/ directories are owned by UID 1000 and have permissions 755.


`docker network connect opencloud_opencloud-net nginx-proxy-manager`

I've also checked and you can do the usual docker manouvre to connect this container to our own docker network by specifying our network instead of opencloud-net and then changing the network session at the bottom to whatever is in all the other container compose files.


#### Opencloud & Web Office (Collabora)

Update the .env file to add the settings required for web office and wopi server. This is all described on the webpage.


## Troubleshooting

The main problem I had was with JWT secret. I had a warning message when trying to bring up the container. I added the following to the docker-compose.yml file.
```
environment:
  - OPENCOLOUD_JWT_SECRET=$(openssl rand -hex 32)
```

I also ran:
`docker compose run --rm opencloud opencloud init --diff` and I think this sorted it.


