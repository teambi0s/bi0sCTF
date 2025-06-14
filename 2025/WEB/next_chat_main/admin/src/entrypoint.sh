#!/bin/sh
set -e

npx prisma generate
npx prisma migrate dev --name init

npm run build
chown -R nextjs:nodejs /app
exec su -s /bin/sh nextjs -c "node server.js"