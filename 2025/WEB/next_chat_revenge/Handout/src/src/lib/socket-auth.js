const jwt = require('jsonwebtoken');

const secret = process.env.NEXTAUTH_SECRET;

const authenticateSocket = async (socket, next) => {
  try {
    const token = socket.handshake.auth.token;

    if (!token) return next(new Error("No auth token"));

    const user = jwt.verify(token, secret);

    if (!user) return next(new Error("Invalid token"));

    socket.user = user;
    next();
  } catch (err) {
    console.error("Socket auth error:", err);
    process.exit(1)
  }
};

module.exports = { authenticateSocket };