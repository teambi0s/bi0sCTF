FROM node:18-alpine

WORKDIR /app

RUN apk add --no-cache \
  libc6-compat \
  ca-certificates \
  chromium \
  nss \
  freetype \
  freetype-dev \
  harfbuzz \
  ttf-freefont \
  udev \
  && fc-cache -f \
  && rm -rf /var/cache/*

RUN addgroup --system --gid 1001 nodejs \
  && adduser --system --uid 1001 nextjs

COPY package*.json ./
RUN npm ci --legacy-peer-deps

COPY . .

RUN echo | npx shadcn@latest add alert avatar \
  badge button card dialog dropdown-menu \
  input label popover progress scroll-area \
  separator sheet sidebar skeleton tabs \
  textarea tooltip switch

ENV NODE_ENV=production
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["/app/entrypoint.sh"]