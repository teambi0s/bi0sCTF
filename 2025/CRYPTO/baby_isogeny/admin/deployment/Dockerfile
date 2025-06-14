FROM sagemath/sagemath:latest

USER root

RUN apt-get update && \
    apt-get install -y \
    socat \
    python3 \
    python3-pip && \
    apt-get clean
RUN sage --pip install pycryptodome

ENV HOME=/home/sage


COPY ./ynetd /ynetd
COPY ./files/* /app/
COPY ./start.sh /app/start.sh

WORKDIR /app

RUN chmod +x /ynetd
RUN chmod +x /app/chall.sage
RUN chmod +x /app/start.sh

EXPOSE 1337
CMD ["/ynetd", "-p", "1337", "./start.sh"]
