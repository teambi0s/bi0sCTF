FROM node:latest

RUN apt-get update && \
    apt-get install -y curl gnupg2 && \
    wget --quiet --output-document=- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /etc/apt/trusted.gpg.d/google-archive.gpg && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
    apt-get update && \
    apt-get install -y google-chrome-stable --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

ENV NODE_ENV=production
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV FLAG=bi0sctf{Wh4t_1s_th3_pr0bl3m?_w4sm,d0mpur1fy_0r_us}

WORKDIR /app

COPY ./package*.json .

RUN npm install

COPY . .



CMD ["node", "app.js"]



