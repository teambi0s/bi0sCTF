FROM python:latest

RUN apt -y update && \
    apt -y upgrade && \
    apt install -y socat && \
    apt install -y pypy3
    
WORKDIR /srv/app
COPY brainf_ck.py .

# PLEASE MAKE SURE THE FLAG LENGTH IS 30 BYTES OR MORE
ENV FLAG="bi0sctf{M4yb3_I_M1sint3rpret3d_th3_t3rm_Tur1ng_c0Mplet3}"
ENV TERM="xterm"

EXPOSE 1337
CMD ["socat","TCP-LISTEN:1337,fork,reuseaddr","exec:pypy3 -u /srv/app/brainf_ck.py"]
