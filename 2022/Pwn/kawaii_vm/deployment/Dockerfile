FROM ubuntu:22.04

RUN apt -y update && \
 	apt -y upgrade

RUN useradd -m ctf
RUN echo "ctf:ctf" | chpasswd

RUN mkdir /home/ctf/lib
WORKDIR /home/ctf/lib
COPY lib .

WORKDIR /home/ctf
COPY kawaii_vm .
COPY flag.txt .
COPY ynetd .

RUN chown -R root:root /home/ctf
RUN chmod -R 0555 /home/ctf

RUN chmod +x /home/ctf/kawaii_vm
RUN chmod +x /home/ctf/lib/*

USER ctf
EXPOSE 1337
CMD ./ynetd -p 1337 "timeout 30 ./kawaii_vm"
