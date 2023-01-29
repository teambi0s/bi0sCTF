FROM ubuntu:22.04

RUN apt update -y && apt upgrade -y
RUN apt install qemu-system python3-pip cpio -y
RUN apt install gcc -y
RUN python3 -m pip install requests

RUN mkdir /pwn
WORKDIR /pwn

COPY pow.py .
COPY rootfs.cpio .
COPY bzImage .
COPY run.sh .
COPY ynetd .

RUN chmod -R 777 /tmp
RUN chmod +x pow.py
RUN chmod +x run.sh
RUN chmod +x ynetd

EXPOSE 1337
CMD ./ynetd -p 1337 "timeout 60 ./pow.py"