import { api } from "@/lib/request";

export const getConversations = async () => {
  const response = await api.get('/conversations');
  return response.data;
};

export const getDirectMessages = async (conversationId) => {
  const response = await api.get(`/conversations/${conversationId}/messages`);
  return response.data;
};

export const createConversation = async (memberTwoId) => {
  const response = await api.post('/conversations', {
    memberTwoId,
  });
  return response.data;
};

export const getUsers = async () => {
  const response = await api.get('/users');
  return response.data;
};

export const getCurrentUser = async () => {
  const response = await api.get('/users/me');
  return response.data;
};

export const getConversationParticipants = async (conversationId) => {
  const response = await api.get(`/conversations/${conversationId}/participants`);
  return response.data;
};

export const searchUsers = async (query) => {
  const response = await api.get(`/users/search?q=${query}`);
  return response.data;
};

export const deleteMessage = async (messageId) => {
  const response = await api.delete(`/direct-messages/${messageId}`);
  return response.data;
};

export const addReaction = async (messageId, emoji) => {
  const response = await api.post(`/direct-messages/${messageId}/reactions`, { emoji });
  return response.data;
};