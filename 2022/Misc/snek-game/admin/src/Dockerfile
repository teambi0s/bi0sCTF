FROM node:16
WORKDIR /app
COPY package*.json ./

ENV FLAG bi0sctf{F4NGT4ST1C_J0B}

RUN npm install
COPY src .
EXPOSE 7000
CMD [ "node", "index.js" ]
