const {
  handleDirectMessage,
  handleTyping,
  handleCreateConversation,
  handleMarkAsRead,
  handleUpdateUserStatus
} = require("./message-handlers.js");
const { prisma } = require("./prisma.js");

const onlineUsers = new Map();

const setupSocketHandlers = (io) => {
  io.on("connection", async (socket) => {
    const userId = socket.user.id;

    try {
      await prisma.user.update({
        where: { id: userId },
        data: {
          status: "ONLINE",
          lastActive: new Date()
        }
      });

      onlineUsers.set(userId, socket.id);

      socket.on("send-direct-message", (data) =>
        handleDirectMessage(socket, io, onlineUsers, data)
      );

      socket.on("typing", (data) =>
        handleTyping(socket, io, onlineUsers, data)
      );

      socket.on("create-conversation", (data) =>
        handleCreateConversation(socket, io, onlineUsers, data)
      );

      socket.on("mark-as-read", (data) =>
        handleMarkAsRead(socket, io, onlineUsers, data)
      );

      socket.on("update-user-status", (data) =>
        handleUpdateUserStatus(socket, data)
      );

      socket.on("disconnect", async () => {
        try {
          onlineUsers.delete(userId);

          await prisma.user.update({
            where: { id: userId },
            data: {
              status: "OFFLINE",
              lastActive: new Date()
            }
          });
        } catch (error) {
          console.error("Error handling disconnect:", error);
        }
      });
    } catch (err) {
      console.error("Error setting up socket handlers:", err);
    }
  });
};

module.exports = { setupSocketHandlers };