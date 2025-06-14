FROM ubuntu:24.10

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install -y socat && \
    apt-get install -y python3 
    
RUN apt-get install -y qemu-system-x86
RUN apt-get install -y cpio 

WORKDIR /home/ubuntu

COPY rootfss/ rootfss/
COPY run_exploit.py .
COPY scripts/ scripts/
COPY kernel/ kernel/
COPY ./flag.txt .

RUN chmod +x kernel/run.sh

EXPOSE 1338
CMD ["socat","-d","tcp-listen:1338,fork,reuseaddr","EXEC:./run_exploit.py"]
