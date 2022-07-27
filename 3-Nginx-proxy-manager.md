## Create a Network
All containers need a network to communicate on. If left unchecked then nginx proxy manager will create one. However here we get ahead of the curve and create one of our own.
We can then add this to the config of later containers.

`sudo docker network create dockernet` but note that for dockernet we could use any network name we want.


## Install Nginx Proxy Manager (NPM)
[Website](https://nginxproxymanager.com/)

Note that this is different to node package manager (npm).

To use this we're going to use a docker-compose file which has the configuration settings in it.
On this occasion we're going to configure it to use _dockernet_ as the network and the files will be in ~/containers/nginx-proxy-manager/
We'll stick to using the builtin sqlite option for storage.


#### docker-compose.yml
```
version: "3"
services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      # These ports are in format <host-port>:<container-port>
      - '80:80' # Public HTTP Port
      - '443:443' # Public HTTPS Port
      - '81:81' # Admin Web Port
      # Add any other Stream port you want to expose
      # - '21:21' # FTP


    volumes:
      - /home/andrew/containers/nginx-progy-manager/data:/data
      - /home/andrew/containers/nginx-progy-manager/letsencrypt:/etc/letsencrypt
      
  networks:
    default:
      external:
        name: dockernet
      
```

This can be uploaded to Portainer and run as a stack, or run from the command line in the directory storing it.
`sudo docker-compose up'

