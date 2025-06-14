FROM fedora:latest

# Install dependencies
RUN dnf -y update && \
    dnf -y install socat python3 python3-pip && \
    dnf clean all

COPY requirements.txt .
RUN pip3 install -r requirements.txt

RUN useradd -m ctf
WORKDIR /home/ctf

COPY . .

RUN chmod +x Shoggi.py

RUN chown -R root:root /home/ctf && \
    chmod -R 555 /home/ctf

USER ctf

EXPOSE 1338

CMD ["socat", "TCP-LISTEN:1338,reuseaddr,fork", "EXEC:'python3 -u Shoggi.py',stderr"]
