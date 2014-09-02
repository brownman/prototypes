cat README.md  | grep '\$' > commands.sh

$ docker build -t [username]/docker-desktop git://github.com/rogaha/docker-desktop.git
$ git clone https://github.com/rogaha/docker-desktop.git
$ cd docker-desktop
$ docker build -t [username]/docker-desktop .
$ CONTAINER_ID=$(docker run -d -P [username]/docker-desktop)
$ echo $(docker logs $CONTAINER_ID | sed -n 1p)
$ docker port $CONTAINER_ID 22
$ ifconfig | grep "inet addr:" 
$ ssh docker@192.168.56.102 -p 49153 "sh -c './docker-desktop -s 800x600 -d 10 > /dev/null 2>&1 &'" # Here is where we use the external port
$ ./docker-desktop -h
$ xpra --ssh="ssh -p 49153" attach ssh:docker@192.168.56.102:10 # user@ip_address:session_number
brownman/docker-01_09_1419_35_55:latest
docker ps -l   | awk -F' ' '{ print $2 }'
docker ps -l   | awk -F' ' '{ print $2 }' | tail -1

docker run $( docker ps -l   | awk -F' ' '{ print $2 }' | tail -1 | cut -d':' -f1 ) whoami

sudo docker run -i -p 22 -p 8000:80 -m /data:/data -t foo/live /bin/bash

./ofer.sh switch brownman/docker-desktop detach
