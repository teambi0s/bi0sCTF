FROM ubuntu:24.10

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install -y socat && \
    apt-get install -y patchelf

RUN useradd -m ctf
RUN echo "ctf:ctf" | chpasswd

WORKDIR /home/ctf

COPY vm_chall .
COPY flag.txt .
COPY ld-linux-x86-64.so.2 .
RUN mkdir libs
COPY libc.so.6 ./libs

RUN patchelf --set-interpreter ./ld-linux-x86-64.so.2 ./vm_chall && \
    patchelf --set-rpath ./libs ./vm_chall

RUN chown -R root:root /home/ctf
RUN chmod -R 555 /home/ctf

USER ctf
EXPOSE 1338
CMD socat TCP-LISTEN:1338,reuseaddr,fork EXEC:"sh -c './vm_chall'"
