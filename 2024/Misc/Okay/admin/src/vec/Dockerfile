FROM node:latest

RUN apt-get update && apt-get install nano iproute2 netcat-traditional -y

WORKDIR /app

COPY package.json .

RUN npm install

COPY net.js .

CMD [ "node","net.js" ]