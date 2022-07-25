## Install Portainer
Portainer needs a volume to keep it's data in. (In Docker you can either use a volume or bind hosts to persist data after container shutdown. Here we set up a volume first.

`sudo docker volume create portainer_data`

Then create a container from the portainer image. Here we map a couple of external ports as well.

```
docker run -d -p 127.0.0.1:8000:8000 -p 127.0.0.1:9000:9000 \
 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock \
 -v portainer_data:/data portainer/portainer-ce:latest
 ```
 
Note that in the docker command above localhost:8000 and localhost:9000 are mapped to ports on the container. This is localhost that docker is running on and so to connect we need a SSH tunnel to that machine:

`ssh -L 9000:127.0.0.1:9000 <user>@<server`
