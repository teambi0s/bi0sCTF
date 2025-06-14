import { toast } from 'sonner';

export const useMessageSending = ({
  message,
  attachedFiles,
  isUploading,
  isSending,
  setIsSending,
  setMessage,
  setAttachedFiles,
  uploadFile,
  resetUploadState,
  onSendMessage
}) => {
  const handleSendMessage = async () => {
    if ((!message.trim() && attachedFiles.length === 0) || isUploading || isSending) {
      return;
    }

    setIsSending(true);
    try {
      let fileUrls = [];
      if (attachedFiles.length > 0) {
        fileUrls = await Promise.all(
          attachedFiles.map(file => uploadFile(file)).filter(Boolean)
        );
        if (fileUrls.length !== attachedFiles.length) {
          throw new Error('Some files failed to upload');
        }
      }

      await onSendMessage?.(message.trim(), fileUrls);
      setMessage('');
      setAttachedFiles([]);
      resetUploadState();
    } catch (error) {
      toast.error("Failed to send message", { 
        description: error.message || "Please check your connection and try again" 
      });
    } finally {
      setIsSending(false);
    }
  };

  return { handleSendMessage };
};