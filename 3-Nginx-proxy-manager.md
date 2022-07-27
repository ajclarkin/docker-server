## Install Nginx Proxy Manager (NPM)
[Website](https://nginxproxymanager.com/)

Note that this is different to node package manager (npm).

To use this we're going to use a docker-compose file which has the configuration settings in it.
This will also create a network which we will then use for all the later containers to join as well. The configuration and data files will be in ~/containers/nginx-proxy-manager/
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
      
```

This can be uploaded to Portainer and run as a stack, or run from the command line in the directory storing it.
`sudo docker-compose up'


### Configuration - Once Container is Running
A default user will be set up as admin@example.com with password changeme. The first time we log in these have to be changed.

To log in we have to use our SSH tunnel at the moment and connect to localhost:81
