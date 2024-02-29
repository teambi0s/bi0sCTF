FROM ubuntu:22.04

RUN apt -y update &&\
    apt -y upgrade

RUN apt -y install python3 python3-requests 
RUN apt -y install qemu-system

RUN useradd -m ctf
RUN echo "ctf:ctf" | chpasswd

WORKDIR /home/ctf
COPY flag.txt .
COPY bzImage .
COPY run.sh .
COPY wrapper.py .
COPY ynetd .
COPY rootfs.ext3 .

RUN chown -R root:root /home/ctf
RUN chmod 0555 /home/ctf
RUN chmod 0444 /home/ctf/*

RUN chmod +x /home/ctf/run.sh
RUN chmod +x /home/ctf/ynetd
RUN mkdir /files
RUN chmod -R 0777 /files

USER ctf
EXPOSE 1337
CMD ./ynetd -p 1337 "timeout 120 python3 wrapper.py"