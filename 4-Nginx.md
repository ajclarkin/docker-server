## Install Nginx
This is what we're going to use for hosting websites. Again there is a docker compose file to create the container.

### File Paths
The default file locations in nginx are */usr/share/nginx/html* for html source files and configuration files in *etc/nginx* - */var/www* is not an nginx standard. We are going to use a bind host
to contain the source files. When any source files change on the filesystem this will be reflected in the container.

There are other options - the files could be copied into the container using a dockerfile but that probably doesn't make much sense if the webpage is changing.

I'm going to create an html folder in my home drive to serve the pages from and this should make backups easier.


#### docker-compose.yml
I've copied some of this from @EDIflyer because he already has it working.

```
version: "3"
services:
  nginx:
    command:
      - nginx
      - -g
      - daemon off;
    container_name: nginx
    entrypoint:
      - /docker-entrypoint.sh
#    environment:
#      - PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    expose:
      - 80/tcp
#    ports:
#      - 80:80
    image: docker.io/nginx:alpine
    networks:
      - nginx-proxy-manager_default
    volumes:
      - /home/andrew/containers/nginx/html:/usr/share/nginx/html

networks:
  nginx-proxy-manager_default:
    external: true
```


### Proxy Host in NPM
Now add a proxy host in the front end of NPM: localhost:8000 (SSH tunnel).
Destination is going to be nginx rather than a hostname and port 80.