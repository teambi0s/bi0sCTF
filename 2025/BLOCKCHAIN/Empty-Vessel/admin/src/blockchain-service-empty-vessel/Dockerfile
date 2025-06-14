FROM python:3.11-slim

RUN useradd -u 1000 -m h4ck3r && \
    apt-get update && \
    apt-get install -y curl git bash && \
    rm -rf /var/lib/apt/lists/*

USER h4ck3r
WORKDIR /home/h4ck3r/chall

ENV SHELL=/bin/bash \
    FOUNDRY_BIN=/home/h4ck3r/.foundry/bin

RUN curl -L https://foundry.paradigm.xyz | bash && \
    bash -c "$FOUNDRY_BIN/foundryup"

ENV PATH="$FOUNDRY_BIN:$PATH"

CMD anvil -a 1 --balance 2 --host 0.0.0.0
