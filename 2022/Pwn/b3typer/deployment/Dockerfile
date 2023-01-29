FROM ubuntu:22.04

RUN apt-get -y update
RUN apt-get -y install software-properties-common
RUN apt-get -y install python3
RUN apt-get -y install libicu-dev
RUN apt-get -y install libatomic1
RUN apt-get -y install libstdc++6

RUN useradd -m ctf

ADD Release/jsc /home/ctf
ADD server.py /home/ctf
ADD ynetd /home/ctf
ADD run.sh /home/ctf
ADD flag /root
ADD readflag /

RUN chmod +x /home/ctf/jsc && \
    chmod +x /home/ctf/server.py && \
    chmod +x /home/ctf/run.sh && \
    chown -R root:ctf /home/ctf && \
    chmod -R 750 /home/ctf/  && \
    chmod 4755 /readflag && \
    chmod 400 /root/flag

USER ctf
WORKDIR /home/ctf
EXPOSE 5555
CMD ./ynetd -p 5555 "timeout 30 ./run.sh"
