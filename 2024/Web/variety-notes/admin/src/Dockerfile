FROM node:latest

RUN apt update && \
    apt install -y curl gnupg2

RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable

ENV NODE_ENV=test
ENV PUPPETEER_SKIP_DOWNLOAD=true
ENV INSTANCE_IP="http://34.18.37.24:"

WORKDIR /usr/src/app
ENV FLAG="bi0sctf{w4it_f0r_th3_n3xt_not3_ch4ll3ng3}"
COPY package*.json ./

RUN npm install

COPY . .

CMD ["node", "index.js"]
