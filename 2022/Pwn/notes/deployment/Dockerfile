FROM ubuntu:22.04

RUN apt -y update && \
    apt -y upgrade

RUN useradd -m ctf
RUN echo "ctf:ctf" | chpasswd
WORKDIR /home/ctf

COPY notes .
COPY flag.txt .
COPY ynetd .

RUN chown -R root:root /home/ctf
RUN chmod -R 555 /home/ctf

RUN chmod +x /home/ctf/*

USER ctf
EXPOSE 1337
CMD ./ynetd -p 1337 "./notes"
