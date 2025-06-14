"use client";

import { createContext, useContext, useState, useEffect } from "react";
import { useRouter, usePathname } from "next/navigation";
import { useSession } from "next-auth/react";
import { 
  getConversations, 
  getDirectMessages,
} from "@/services/api-service";
import socketService from "@/services/socket-service";

const ChatContext = createContext();

export const useChatContext = () => {
  return useContext(ChatContext);
};

export function ChatProvider({ children }) {
  const router = useRouter();
  const pathname = usePathname();
  const { data: session, status } = useSession();
  const [conversations, setConversations] = useState([]);
  const [activeEntityId, setActiveEntityId] = useState(null);
  const [messages, setMessages] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState("");
  const [userStatus, setUserStatus] = useState("ONLINE");
  const [typingUsers, setTypingUsers] = useState({});

  useEffect(() => {
    const syncWithUrl = () => {
      const match = pathname.match(/\/chat\/([a-zA-Z0-9_-]+)/);
      if (match && match[1]) {
        const chatId = match[1];
        
        const conversation = conversations.find(c => c.id === chatId);
        if (conversation) {
          setActiveEntityId(chatId);
          return;
        }
      }
    };
    
    if (!loading && conversations.length > 0) {
      syncWithUrl();
    }
  }, [pathname, conversations, loading]);

  useEffect(() => {
    if (status !== "authenticated" || !session?.user?.id) {
      console.warn("Session not authenticated, skipping socket initialization");
      return;
    }

    let token = session?.socketToken;
    if (!token) {
      console.warn("No auth token");
      return;
    }

    socketService.connect(token);

    const unsubscribeConnect = socketService.on("connect", () => {
      setUserStatus("ONLINE");
      socketService.updateUserStatus("ONLINE");
    });

    const unsubscribeDisconnect = socketService.on("disconnect", () => {
      setUserStatus("OFFLINE");
    });

    const unsubscribeConnectError = socketService.on("connect_error", (error) => {
      if (typeof window !== "undefined" && window?.toast) {
        window.toast.error("Connection error", { 
          description: error.message === "No auth token" 
            ? "Authentication failed. Please sign in again." 
            : "Failed to connect to the server. Messages will be queued."
        });
      }
    });

    const unsubscribeDirectMessage = socketService.on("direct-message", (message) => {
      if (activeEntityId === message.conversationId) {
        setMessages((prev) => [...prev, message]);
        
        socketService.markAsRead("conversation", message.conversationId);
      }
      
      setConversations((prev) => 
        prev.map((convo) => {
          if (convo.id === message.conversationId) {
            return {
              ...convo,
              lastMessage: message.content,
              timestamp: message.createdAt,
              unread: activeEntityId === message.conversationId ? 0 : (convo.unread || 0) + 1
            };
          }
          return convo;
        })
      );
    });

    const unsubscribeMessageSent = socketService.on("message-sent", () => {
      if (typeof window !== "undefined" && window?.toast) {
        window.toast.success("Message sent");
      }
    });

    const unsubscribeUserTyping = socketService.on("user-typing", (data) => {
      const { conversationId, userId, isTyping } = data;
      
      setTypingUsers(prev => {
        if (!conversationId) return prev;
        
        if (!prev[conversationId]) {
          prev[conversationId] = {};
        }
        
        return {
          ...prev,
          [conversationId]: {
            ...prev[conversationId],
            [userId]: isTyping
          }
        };
      });
    });

    const unsubscribeTypingTimeout = socketService.on("typing-timeout", (data) => {
      const { entityId, userId } = data;
      
      setTypingUsers(prev => {
        if (!prev[entityId] || !prev[entityId][userId]) return prev;
        
        const newTypingUsers = {
          ...prev,
          [entityId]: {
            ...prev[entityId]
          }
        };
        
        delete newTypingUsers[entityId][userId];
        
        return newTypingUsers;
      });
    });

    const unsubscribeUserStatusChange = socketService.on("user-status-change", (data) => {
      const { userId, status } = data;
      
      setConversations(prev => 
        prev.map(convo => {
          const otherMember = convo.memberOne.id === session.user.id ? convo.memberTwo : convo.memberOne;
          if (otherMember.id === userId) {
            return {
              ...convo,
              otherMember: {
                ...otherMember,
                status
              }
            };
          }
          return convo;
        })
      );
    });

    const unsubscribeError = socketService.on("error", (error) => {
      if (typeof window !== "undefined" && window?.toast) {
        window.toast.error("Socket error", { description: error.message || "An error occurred" });
      }
    });

    const unsubscribeMessageQueued = socketService.on("message-queued", () => {
      if (typeof window !== "undefined" && window?.toast) {
        window.toast.warning("Offline", { description: "Message queued, will send when reconnected" });
      }
    });

    return () => {
      unsubscribeConnect();
      unsubscribeDisconnect();
      unsubscribeConnectError();
      unsubscribeDirectMessage();
      unsubscribeMessageSent();
      unsubscribeUserTyping();
      unsubscribeTypingTimeout();
      unsubscribeUserStatusChange();
      unsubscribeError();
      unsubscribeMessageQueued();
      socketService.disconnect();
    };
  }, [session, status, activeEntityId]);

  useEffect(() => {
    if (activeEntityId && socketService.isConnected()) {
      socketService.markAsRead("conversation", activeEntityId);
      
      setConversations(prev => 
        prev.map(convo => 
          convo.id === activeEntityId ? { ...convo, unread: 0 } : convo
        )
      );
    }
  }, [activeEntityId]);

  useEffect(() => {
    const fetchData = async () => {
      if (status !== "authenticated") return;
      
      try {
        setLoading(true);
        const conversationsData = await getConversations();
        setConversations(conversationsData);
      } catch (error) {
        console.error("Error fetching data:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [status]);

  useEffect(() => {
    const fetchMessages = async () => {
      if (!activeEntityId) return;
      
      try {
        setLoading(true);
        const messagesData = await getDirectMessages(activeEntityId);
        
        setMessages(messagesData);
        
        if (socketService.isConnected()) {
          socketService.markAsRead("conversation", activeEntityId);
        }
      } catch (error) {
        console.error("Error fetching messages:", error);
        if (typeof window !== "undefined" && window?.toast) {
          window.toast.error("Failed to load messages", { description: error.message });
        }
      } finally {
        setLoading(false);
      }
    };

    fetchMessages();
  }, [activeEntityId]);

  const sendMessage = (content, fileUrls = []) => {
    if (!activeEntityId || (!content?.trim() && fileUrls.length === 0)) {
      console.warn("Cannot send message: Invalid input");
      if (typeof window !== "undefined" && window?.toast) {
        window.toast.error("Cannot send message", { description: "Please enter a message or attach a file" });
      }
      return;
    }

    socketService.sendDirectMessage(activeEntityId, content, fileUrls);
  };
  
  const getActiveEntity = () => {
    if (!activeEntityId) return null;
    return conversations.find(c => c.id === activeEntityId);
  };
  
  const filteredChats = () => {
    const allChats = conversations.map(c => ({ ...c, type: "conversation" }))
      .sort((a, b) => {
        const timeA = new Date(a.timestamp || a.updatedAt).getTime();
        const timeB = new Date(b.timestamp || b.updatedAt).getTime();
        return timeB - timeA;
      });
    
    if (!searchQuery) return allChats;
    
    return allChats.filter(chat => 
      chat.name?.toLowerCase().includes(searchQuery.toLowerCase()) ||
      chat.otherMember?.name?.toLowerCase().includes(searchQuery.toLowerCase())
    );
  };
  
  const setActiveChat = (id) => {
    setActiveEntityId(id);
    
    if (id) {
      router.push(`/chat/${id}`, { scroll: false });
      
      if (socketService.isConnected()) {
        socketService.markAsRead("conversation", id);
      }
    }
  };
  
  const updateStatus = async (status) => {
    try {
      setUserStatus(status);
      
      if (socketService.isConnected()) {
        socketService.updateUserStatus(status);
      }
    } catch (error) {
      console.error("Error updating status:", error);
    }
  };
  
  const sendTypingIndicator = () => {
    if (!activeEntityId) return;
    
    socketService.sendTypingIndicator("conversation", activeEntityId);
  };
  
  const getTypingUsers = (entityId) => {
    if (!entityId || !typingUsers[entityId]) return [];
    
    return Object.keys(typingUsers[entityId]).filter(userId => 
      typingUsers[entityId][userId] && userId !== session?.user?.id
    );
  };

  const value = {
    conversations,
    messages,
    loading,
    activeEntityId,
    searchQuery,
    setSearchQuery,
    userStatus,
    sendMessage,
    getActiveEntity,
    filteredChats,
    setActiveChat,
    updateStatus,
    sendTypingIndicator,
    getTypingUsers,
    socket: socketService.getSocket()
  };

  return (
    <ChatContext.Provider value={value}>
      {children}
    </ChatContext.Provider>
  );
}