# Docker Server
Various config settings for linux server running docker. Inspired by @EDIflyer.

## Server
For this I'm using a Compute Engine VM on Google Cloud Platform. I've started with the e2-micro with 10Gb standard disc which is included in the free tier so shouldn't cost anything. (I've already got another of these running and it ends up costing me about 90p per month but I think that's because I configured the wrong storage.)

I'm running Debian 11.


## Install Docker
[Instructions](https://docs.docker.com/engine/install/debian/)

```
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
    

 # Add GPG key
 sudo mkdir -p /etc/apt/keyrings
 curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
 
 # Set up repository
 echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
  
  # Install Docker Engine
  sudo apt-get update 
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin


  # Verify that it is working 
  sudo docker run hello-world
   
```

After installation you can create a docker group to avoid having to use sudo for each command. I have not done that to keep it more secure.


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

