#sudo docker build -t antennas .
#sudo docker run -d -p 5000:5000 --rm antennas

FROM python:alpine

RUN apk update
RUN apk add socat
RUN export TERM="xterm-256color"

RUN adduser -D ctf -u 1000 -g 1000

### diretory setting
COPY --chown=ctf:ctf ./chall.py /home/ctf/chall.py
COPY --chown=ctf:ctf ./RMT.py /home/ctf/RMT.py
COPY --chown=ctf:ctf ./decor.py /home/ctf/decor.py

USER ctf

RUN pip install --upgrade pip
RUN pip install tinyec
RUN pip install pycryptodome


EXPOSE 5000

WORKDIR /home/ctf

CMD ["/usr/bin/socat", "tcp-listen:5000,reuseaddr,fork", "exec:\"python3 -u /home/ctf/chall.py\""]