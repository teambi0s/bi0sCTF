FROM node:16
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY src .
EXPOSE 7000
CMD [ "node", "index.js" ]