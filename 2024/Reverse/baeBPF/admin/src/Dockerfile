FROM ubuntu:20.04
RUN apt-get -q -y update && \
    apt-get -q -y install \
    python3-dev \
    python3-pip

COPY ./baebpf.py .
COPY ./part1.txt .
COPY ./part2.txt .
COPY ./test.py .
COPY ./entrypoint.sh .
COPY ./ynetd .

RUN chmod +x entrypoint.sh
RUN chmod +x ynetd

EXPOSE 1337
CMD ./ynetd -p 1337 "timeout 180s ./entrypoint.sh"