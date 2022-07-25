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
