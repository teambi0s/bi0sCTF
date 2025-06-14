FROM ubuntu:25.04

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install -y socat

RUN useradd -m ctf
RUN echo "ctf:ctf" | chpasswd

WORKDIR /home/ctf

COPY main .
COPY flag.txt .

RUN chown -R root:root /home/ctf
RUN chmod -R 555 /home/ctf

USER ctf
EXPOSE 1338
CMD socat TCP-LISTEN:1338,reuseaddr,fork EXEC:"sh -c './main'"