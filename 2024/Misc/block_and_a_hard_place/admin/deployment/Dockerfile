FROM ubuntu:20.04
RUN apt-get -q -y update && \
    apt-get -q -y install \
    python3-dev \
    xinetd \
    python3-pip

COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY ./ctf.xinetd /etc/xinetd.d/ctf
RUN echo "Blocked by ctf_xinetd" > /etc/banner_fail

COPY ./files/* ./

CMD ["xinetd", "-dontfork"]

EXPOSE 1337