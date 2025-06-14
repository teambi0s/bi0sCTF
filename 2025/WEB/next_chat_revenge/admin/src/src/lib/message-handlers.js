const { prisma } = require("./prisma.js");

const handleDirectMessage = async (socket, io, onlineUsers, data) => {
  try {
    const userId = socket.user.id;
    const { conversationId, content, fileUrls = [] } = data;

    const conversation = await prisma.conversation.findUnique({
      where: {
        id: conversationId,
        OR: [
          { memberOneId: userId },
          { memberTwoId: userId }
        ]
      },
      include: {
        memberOne: true,
        memberTwo: true
      }
    });

    if (!conversation) {
      socket.emit("error", { message: "Conversation not found" });
      return;
    }

    const recipientId = conversation.memberOneId === userId 
      ? conversation.memberTwoId 
      : conversation.memberOneId;

    let messages = [];

    if (content && content.trim()) {
      const textMessage = await prisma.sentDirectMessage.create({
        data: {
          content,
          senderId: userId,
          conversationId
        },
        include: {
          sender: {
            select: {
              id: true,
              name: true,
              image: true
            }
          }
        }
      });
      messages.push(textMessage);
    }

    for (const fileUrl of fileUrls) {
      const fileMessage = await prisma.sentDirectMessage.create({
        data: {
          content: 'File attachment',
          fileUrl,
          senderId: userId,
          conversationId
        },
        include: {
          sender: {
            select: {
              id: true,
              name: true,
              image: true
            }
          }
        }
      });
      messages.push(fileMessage);
    }

    for (const message of messages) {
      socket.emit("direct-message", message);

      const recipientSocketId = onlineUsers.get(recipientId);
      if (recipientSocketId) {
        io.to(recipientSocketId).emit("direct-message", message);
      }
    }
  } catch (error) {
    console.error("Error sending direct message:", error);
    socket.emit("error", { message: "Failed to send message" });
  }
};

const handleTyping = async (socket, io, onlineUsers, data) => {
  const userId = socket.user.id;
  const { entityType, entityId } = data;

  if (entityType === 'conversation') {
    const conversation = await prisma.conversation.findUnique({
      where: {
        id: entityId,
        OR: [
          { memberOneId: userId },
          { memberTwoId: userId }
        ]
      }
    });

    if (!conversation) return;

    const recipientId = conversation.memberOneId === userId
      ? conversation.memberTwoId
      : conversation.memberOneId;

    const recipientSocketId = onlineUsers.get(recipientId);
    if (recipientSocketId) {
      io.to(recipientSocketId).emit("user-typing", {
        conversationId: entityId,
        userId,
        isTyping: true
      });
    }
  }
};

const handleCreateConversation = async (socket, io, onlineUsers, data) => {
  try {
    const userId = socket.user.id;
    const { otherUserId } = data;

    const existingConversation = await prisma.conversation.findFirst({
      where: {
        OR: [
          {
            memberOneId: userId,
            memberTwoId: otherUserId
          },
          {
            memberOneId: otherUserId,
            memberTwoId: userId
          }
        ]
      },
      include: {
        memberOne: {
          select: {
            id: true,
            name: true,
            image: true,
            status: true
          }
        },
        memberTwo: {
          select: {
            id: true,
            name: true,
            image: true,
            status: true
          }
        }
      }
    });

    if (existingConversation) {
      socket.emit("new-conversation", existingConversation);
      return;
    }

    const newConversation = await prisma.conversation.create({
      data: {
        memberOneId: userId,
        memberTwoId: otherUserId
      },
      include: {
        memberOne: {
          select: {
            id: true,
            name: true,
            image: true,
            status: true
          }
        },
        memberTwo: {
          select: {
            id: true,
            name: true,
            image: true,
            status: true
          }
        }
      }
    });

    socket.emit("new-conversation", newConversation);

    const otherUserSocketId = onlineUsers.get(otherUserId);
    if (otherUserSocketId) {
      io.to(otherUserSocketId).emit("new-conversation", newConversation);
    }

  } catch (error) {
    console.error("Error creating conversation:", error);
    socket.emit("error", { message: "Failed to create conversation" });
  }
};

const handleMarkAsRead = async (socket, io, onlineUsers, data) => {
  try {
    const userId = socket.user.id;
    const { entityType, entityId } = data;

    if (entityType === 'conversation') {
      const conversation = await prisma.conversation.findFirst({
        where: {
          id: entityId,
          OR: [
            { memberOneId: userId },
            { memberTwoId: userId }
          ]
        }
      });

      if (!conversation) return;

      const otherUserId = conversation.memberOneId === userId
        ? conversation.memberTwoId
        : conversation.memberOneId;

      const otherUserSocketId = onlineUsers.get(otherUserId);
      if (otherUserSocketId) {
        io.to(otherUserSocketId).emit("message-read", {
          conversationId: entityId,
          readBy: userId
        });
      }
    }

  } catch (error) {
    console.error("Error marking as read:", error);
  }
};

const handleUpdateUserStatus = async (socket, data) => {
  try {
    const userId = socket.user.id;
    const { status } = data;

    await prisma.user.update({
      where: { id: userId },
      data: {
        status,
        lastActive: new Date()
      }
    });
  } catch (error) {
    console.error("Error updating user status:", error);
  }
};

module.exports = {
  handleDirectMessage,
  handleTyping,
  handleCreateConversation,
  handleMarkAsRead,
  handleUpdateUserStatus
};