import { useState } from 'react';

export const useFileUpload = () => {
  const [isUploading, setIsUploading] = useState(false);
  const [uploadProgress, setUploadProgress] = useState(0);
  const [uploadError, setUploadError] = useState(null);
  const [fileDetails, setFileDetails] = useState(null);

  const uploadFile = async (file, options = {}) => {
    if (!file) return null;
    
    try {
      setIsUploading(true);
      setUploadProgress(0);
      setUploadError(null);
      setFileDetails(null);
      
      const formData = new FormData();
      formData.append('file', file);
      
      if (options.context && options.targetId) {
        formData.append('context', JSON.stringify({
          type: options.context,
          targetId: options.targetId,
          ...(options.metadata || {})
        }));
      }
      
      const progressInterval = setInterval(() => {
        setUploadProgress(prev => {
          if (prev >= 95) return prev;
          return prev + Math.floor(Math.random() * 8) + 2;
        });
      }, 300);
      
      const response = await fetch('/api/upload', {
        method: 'POST',
        body: formData,
      });
      
      clearInterval(progressInterval);
      
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || 'File upload failed');
      }
      
      const data = await response.json();
      
      setUploadProgress(100);
      
      const fileInfo = {
        url: data.fileUrl,
        name: file.name,
        size: file.size,
        type: file.type,
        context: options.context,
        targetId: options.targetId,
        uploadedAt: new Date().toISOString()
      };
      
      setFileDetails(fileInfo);
      
      return data.fileUrl;
      
    } catch (error) {
      console.error('Upload error:', error);
      setUploadError(error.message || 'An error occurred during upload');
      return null;
    } finally {
      if (uploadProgress !== 100) {
        setIsUploading(false);
      } else {
        setTimeout(() => {
          setIsUploading(false);
        }, 800);
      }
    }
  };

  const getFiles = async (options = {}) => {
    const { type = 'all', groupId, page = 1, limit = 20 } = options;
    
    try {
      const queryParams = new URLSearchParams({
        type,
        page: page.toString(),
        limit: limit.toString()
      });
      
      if (groupId) {
        queryParams.append('groupId', groupId);
      }
      
      const response = await fetch(`/api/files?${queryParams}`);
      
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || 'Failed to retrieve files');
      }
      
      return await response.json();
      
    } catch (error) {
      console.error('Error retrieving files:', error);
      throw error;
    }
  };
  
  return {
    uploadFile,
    getFiles,
    isUploading,
    uploadProgress,
    uploadError,
    fileDetails,
    resetUploadState: () => {
      setIsUploading(false);
      setUploadProgress(0);
      setUploadError(null);
      setFileDetails(null);
    }
  };
};