FROM ubuntu:20.04
RUN apt-get -q -y update && \
    apt-get -q -y install \
    python3-dev \
    python3-pip

COPY ./files/* ./
COPY ./ynetd ./
COPY ./run.sh ./
RUN chmod +x ./ynetd
RUN chmod +x ./run.sh

EXPOSE 1337
CMD ./ynetd -p 1337 "timeout 150 ./run.sh"