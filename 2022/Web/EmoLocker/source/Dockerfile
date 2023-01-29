FROM node:latest

WORKDIR /app

RUN mkdir -p /app/backend/ && mkdir -p /app/frontend/

RUN npm install -g n 

COPY ./src/backend/package.json /app/backend/

COPY ./src/frontend/build/. /app/frontend/build/

RUN cd /app/backend && npm install

COPY ./src/backend/. /app/backend

ENV EMOPIN "51 32 73 34 85 126 17 158 79 50"

ENV FLAG "bi0sCTF{a34522e2009192570c840f931e4c3c0a}"

CMD ["node", "/app/backend/server.js"]