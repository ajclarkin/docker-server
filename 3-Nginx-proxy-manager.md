## Network
All containers need a network to communicate on. If left unchecked then nginx proxy manager will create one. However here we get ahead of the curve and create one of our own.
We can then add this to the config of later containers.

`sudo docker network create dockernet` but note that for dockernet we could use any network name we want.
