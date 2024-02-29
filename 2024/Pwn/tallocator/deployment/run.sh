#!/bin/bash

docker build -t bi0sctf -f Dockerfile . || exit 1
docker rm bi0sctf 2> /dev/null
docker run -d --name bi0sctf -it --net=host -p 1338:1338 --privileged -v /dev/kvm:/dev/kvm bi0sctf || exit 1
echo -e "\nServer is running on localhost:1338, ctrl+c to exit"
docker attach bi0sctf