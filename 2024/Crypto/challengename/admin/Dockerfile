FROM ubuntu:20.04
RUN apt-get -q -y update && \
    apt-get -q -y install \
    python3-dev \
    python3-pip 

COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY ./ynetd .
COPY ./files/* ./

RUN chmod +x ynetd
RUN chmod +x server.py

EXPOSE 1337
CMD ./ynetd -p 1337 "./server.py"