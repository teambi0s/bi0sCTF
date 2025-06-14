"use client";

import { io } from 'socket.io-client';

export class SocketService {
  constructor() {
    this.socket = null;
    this.listeners = new Map();
    this.queuedMessages = [];
    this.retryConfig = { attempts: 0, timeout: null, maxAttempts: 5, delay: 1000 };
    this.typingTimeouts = {};
  }

  connect(token) {
    if (this.socket) {
      this.disconnect();
    }

    if (!token) {
      console.warn('No auth token provided for socket connection');
      return null;
    }

    const socketUrl = process.env.NEXT_PUBLIC_SOCKET_URL || (typeof window !== 'undefined' ? window.location.origin : '');

    this.socket = io(socketUrl, {
      path: '/socket.io',
      auth: { token },
      transports: ['websocket', 'polling'],
      reconnection: true,
      reconnectionAttempts: 5,
      reconnectionDelay: 1000
    });

    this.setupDefaultListeners();
    return this.socket;
  }

  setupDefaultListeners() {
    this.socket.on('connect', () => {
      this.retryConfig.attempts = 0;
      this.executeCallback('connect');
      
      if (this.queuedMessages.length > 0) {
        this.processQueuedMessages();
      }
    });

    this.socket.on('connect_error', (error) => {
      console.error('Socket connection error:', {
        message: error.message,
        description: error.description,
        type: error.type,
        data: error.data
      });
      this.executeCallback('connect_error', error);
    });

    this.socket.on('disconnect', (reason) => {
      this.executeCallback('disconnect', reason);
    });

    this.socket.on('direct-message', (message) => {
      this.executeCallback('direct-message', message);
    });

    this.socket.on('message-sent', (data) => {
      this.executeCallback('message-sent', data);
    });

    this.socket.on('user-typing', (data) => {
      this.executeCallback('user-typing', data);
      this.handleTypingTimeout(data);
    });

    this.socket.on('message-read', (data) => {
      this.executeCallback('message-read', data);
    });

    this.socket.on('user-status-change', (data) => {
      this.executeCallback('user-status-change', data);
    });

    this.socket.on('error', (error) => {
      console.error('Socket error:', error);
      this.executeCallback('error', error);
    });
  }

  handleTypingTimeout(data) {
    const { conversationId, userId, isTyping } = data;
    if (!isTyping || !conversationId) return;
    
    const timeoutKey = `${conversationId}-${userId}`;
    
    if (this.typingTimeouts[timeoutKey]) {
      clearTimeout(this.typingTimeouts[timeoutKey]);
    }
    
    this.typingTimeouts[timeoutKey] = setTimeout(() => {
      this.executeCallback('typing-timeout', { 
        entityId: conversationId, 
        userId,
        conversationId
      });
      delete this.typingTimeouts[timeoutKey];
    }, 3000);
  }

  on(event, callback) {
    if (!this.listeners.has(event)) {
      this.listeners.set(event, []);
    }
    this.listeners.get(event).push(callback);
    
    return () => {
      const callbacks = this.listeners.get(event) || [];
      const index = callbacks.indexOf(callback);
      if (index !== -1) {
        callbacks.splice(index, 1);
      }
    };
  }

  executeCallback(event, data) {
    const callbacks = this.listeners.get(event) || [];
    callbacks.forEach(callback => callback(data));
  }

  sendDirectMessage(conversationId, content, fileUrls = []) {
    if (!this.isConnected()) {
      this.queueMessage('direct', conversationId, content, fileUrls);
      return false;
    }

    try {
      this.socket.emit('send-direct-message', {
        conversationId,
        content: content?.trim() || '',
        fileUrls
      });
      return true;
    } catch (error) {
      console.error('Error sending direct message:', error);
      return false;
    }
  }

  queueMessage(type, entityId, content, fileUrls) {
    console.warn('Socket not connected, queuing message');
    this.queuedMessages.push({
      type,
      entityId,
      content,
      fileUrls
    });
    this.executeCallback('message-queued', {
      type,
      entityId,
      content,
      fileUrls
    });
  }

  processQueuedMessages() {
    if (!this.isConnected()) return;
    
    while (this.queuedMessages.length > 0) {
      const message = this.queuedMessages.shift();
      this.sendDirectMessage(message.entityId, message.content, message.fileUrls);
    }
  }

  markAsRead(entityType, entityId) {
    if (!this.isConnected() || !entityType || !entityId) return false;
    
    try {
      this.socket.emit('mark-as-read', { entityType, entityId });
      return true;
    } catch (error) {
      console.error('Error marking as read:', error);
      return false;
    }
  }

  sendTypingIndicator(entityType, entityId) {
    if (!this.isConnected() || !entityType || !entityId) return;
    
    try {
      this.socket.emit('typing', { entityType, entityId });
    } catch (error) {
      console.error('Error sending typing indicator:', error);
    }
  }

  updateUserStatus(status) {
    if (!this.isConnected()) return false;
    
    try {
      this.socket.emit('update-user-status', { status });
      return true;
    } catch (error) {
      console.error('Error updating user status:', error);
      return false;
    }
  }

  isConnected() {
    return this.socket && this.socket.connected;
  }

  disconnect() {
    if (this.socket) {
      Object.values(this.typingTimeouts).forEach(clearTimeout);
      this.typingTimeouts = {};
      
      this.socket.disconnect();
      this.socket = null;
    }
  }

  getSocket() {
    return this.socket;
  }
}

const socketService = new SocketService();
export default socketService;