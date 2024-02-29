FROM ubuntu:22.04

RUN apt -y update &&\
    apt -y upgrade

RUN apt -y install python3 python3-requests 

RUN useradd -m ctf
RUN echo "ctf:ctf" | chpasswd

WORKDIR /home/ctf
COPY flag.txt .
COPY bzImage .
COPY qemu-system-x86_64 .
COPY run.sh .
COPY wrapper.py .
COPY ynetd .
COPY rootfs.ext3 .

RUN mkdir /home/ctf/bin
WORKDIR /home/ctf/bin
COPY bin .

WORKDIR /home/ctf
RUN chown -R root:root /home/ctf
RUN chmod 0555 /home/ctf
RUN chmod 0444 /home/ctf/*
RUN chmod -R 0555 /home/ctf/bin

RUN chmod +x /home/ctf/qemu-system-x86_64
RUN chmod +x /home/ctf/run.sh
RUN chmod +x /home/ctf/ynetd

USER ctf
EXPOSE 1337
CMD ./ynetd -p 1337 "timeout 480 python3 wrapper.py"