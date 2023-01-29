#!/bin/sh
export PYTHONDONTWRITEBYTECODE=1

mv flag.txt $(head /dev/urandom | shasum | cut -d' ' -f1)

htpasswd -mbc /etc/.htpasswd admin ­

spawn-fcgi -s /var/run/fcgiwrap.socket -M 766 /usr/sbin/fcgiwrap 

/usr/sbin/nginx

while true; do sleep 1; done