FROM python:3.11-slim

RUN useradd -u 1000 -m h4ck3r && \
    apt-get update && \
    apt-get install -y curl git bash netcat-openbsd jq && \
    apt-get install -y make && \
    rm -rf /var/lib/apt/lists/*

USER h4ck3r
WORKDIR /home/h4ck3r/chall

ENV SHELL=/bin/bash \
    FOUNDRY_BIN=/home/h4ck3r/.foundry/bin

RUN curl -L https://foundry.paradigm.xyz | bash && \
    bash -c "$FOUNDRY_BIN/foundryup"

ENV PATH="$FOUNDRY_BIN:$PATH"

RUN forge init

RUN rm -rf ./src ./script ./test ./foundry.toml

COPY foundry.toml ./
COPY src /home/h4ck3r/chall/src
COPY script /home/h4ck3r/chall/script
COPY remappings.txt /home/h4ck3r/chall/
COPY makefile /home/h4ck3r/chall/
COPY main.py ./
COPY requirements.txt ./
COPY .env ./

RUN pip install -r requirements.txt

CMD python3 main.py



