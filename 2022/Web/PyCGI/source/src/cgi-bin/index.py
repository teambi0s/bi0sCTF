#!/usr/bin/python3

from server import Server

try:
    server = Server()
    server.set_header("Content-Type", "text/html")
    server.send_file("../templates/index.html")
    server.send_response()
except Exception as e:
    print(str(e))