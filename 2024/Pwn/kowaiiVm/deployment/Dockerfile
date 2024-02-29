FROM archlinux

RUN pacman -Syu --noconfirm

RUN useradd -m ctf
RUN echo "ctf:ctf" | chpasswd

WORKDIR /home/ctf
COPY flag.txt .
COPY ynetd .
COPY kowaiiVm .

RUN chown -R root:root /home/ctf
RUN chmod 0555 /home/ctf
RUN chmod 0444 /home/ctf/*

RUN chmod +x /home/ctf/kowaiiVm
RUN chmod +x /home/ctf/ynetd

USER ctf
EXPOSE 1337
CMD ./ynetd -p 1337 "timeout 60 ./kowaiiVm"