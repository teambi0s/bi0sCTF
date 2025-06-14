FROM python:alpine

RUN apk update
RUN apk add socat

RUN adduser -D ctf -u 1000 -g 1000

COPY --chown=ctf:ctf ./chall.py /home/ctf/chall.py
COPY --chown=ctf:ctf ./message.txt /home/ctf/message.txt

USER ctf

RUN pip install --upgrade pip
RUN pip install pycryptodome

EXPOSE 5000

WORKDIR /home/ctf

CMD ["/usr/bin/socat", "tcp-listen:5000,reuseaddr,fork", "exec:python3 -u /home/ctf/chall.py"]