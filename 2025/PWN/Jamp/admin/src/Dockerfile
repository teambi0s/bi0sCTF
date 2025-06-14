FROM fedora@sha256:d0207dbb078ee261852590b9a8f1ab1f8320547be79a2f39af9f3d23db33735e

RUN dnf -y update && dnf -y install httpd git  && dnf clean all
RUN dnf -y install socat
RUN dnf -y install python3-pip
RUN pip3 install pwntools


RUN useradd -m ctf
RUN echo "ctf:ctf" | chpasswd
WORKDIR /home/ctf

COPY JAMP .
COPY flag.txt .
COPY runner.py .

RUN chmod +X JAMP
RUN chmod +X runner.py

RUN chown -R root:root /home/ctf
RUN chmod -R 555 /home/ctf

USER ctf
EXPOSE 1338
CMD ["socat","-d","tcp-listen:1338,fork,reuseaddr","EXEC:./runner.py"]

