FROM sagemath/sagemath:9.6

USER root

RUN apt-get update && \
    apt-get install -y \
    socat \
    python3 \
    python3-pip && \
    apt-get clean
RUN sage --pip install pycryptodome

ENV FLAG="bi0sctf{th4t_w4snt_t0o_c0mpl3x}"
ENV HOME=/home/sage


COPY ./ynetd /ynetd
COPY ./files/* /app/
COPY ./start.sh /app/start.sh

WORKDIR /app

RUN chmod +x /ynetd
RUN chmod +x /app/chal.sage
RUN chmod +x /app/start.sh

EXPOSE 1337
CMD ["/ynetd", "-p", "1337", "./start.sh"]
