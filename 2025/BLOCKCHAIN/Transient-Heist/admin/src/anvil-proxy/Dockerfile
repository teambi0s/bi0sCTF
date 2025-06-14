FROM python:3.11-slim

RUN useradd -u 1000 -m h4ck3r && \
    apt-get update && \
    apt-get install -y curl git bash && \
    rm -rf /var/lib/apt/lists/*

USER h4ck3r
WORKDIR /home/h4ck3r/chall

COPY main.py ./main.py
COPY requirements.txt ./requirements.txt
RUN pip3 install -r requirements.txt

CMD python3 main.py
