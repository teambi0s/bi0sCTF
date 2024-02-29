docker build -t tallocator .
docker run -d -it --net=host --privileged -v /dev/kvm:/dev/kvm tallocator