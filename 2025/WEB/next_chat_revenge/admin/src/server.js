const { createServer } = require('node:http');
const next = require('next');
const { Server } = require('socket.io');
const { initAdmin } = require('./src/lib/admin.js');
const { setupSocketHandlers } = require('./src/lib/socket-handlers.js');
const { authenticateSocket } = require('./src/lib/socket-auth.js');

const dev = process.env.NODE_ENV !== "production";
const hostname = process.env.HOSTNAME || "0.0.0.0";
const port = process.env.PORT || 3000;
const app = next({ dev, hostname, port });
const handler = app.getRequestHandler();

const origin = process.env.NEXT_PUBLIC_APP_URL;

app.prepare().then(async () => {
  try {
    await initAdmin();
  } catch (err) {
    console.error("Failed to create admin user:", err);
    process.exit(1);
  }

  const httpServer = createServer(handler);
  const io = new Server(httpServer, {
    cors: {
      origin,
      credentials: true,
    },
  });

  io.use(authenticateSocket);

  setupSocketHandlers(io);

  httpServer
    .once("error", (err) => {
      console.error(err);
      process.exit(1);
    })
    .listen(port, () => {
      console.log(`> Ready on http://${hostname}:${port}`);
    });
});