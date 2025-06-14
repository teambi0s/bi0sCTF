"use client";

import { useState, useRef, useEffect } from "react";
import { Send, X, Plus } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Switch } from "@/components/ui/switch";
import { Label } from "@/components/ui/label";
import { Toaster, toast } from 'sonner';
import { useFileUpload } from "@/hooks/use-file-upload";
import FileAttachment from "@/components/others/file-attachment";
import FileUploadMenu from "./file-upload-menu";
import ProgressIndicator from "./progress-indicator";
import ActionButtons from "./action-buttons";
import { useMessageSending } from "@/hooks/use-message-sending";
import { useTextareaResize } from "@/hooks/use-textarea-resize";

export default function MessageInputBar({ activeChat, onSendMessage }) {
  const [message, setMessage] = useState('');
  const [attachedFiles, setAttachedFiles] = useState([]);
  const [isSending, setIsSending] = useState(false);
  const [showCollageDialog, setShowCollageDialog] = useState(false);
  const [collageImages, setCollageImages] = useState([]);
  const [collageBackground, setCollageBackground] = useState(false);
  const textareaRef = useRef(null);
  const fileInputRef = useRef(null);
  const collageFileInputRef = useRef(null);
  
  const { uploadFile, isUploading, uploadProgress, resetUploadState } = useFileUpload();

  const { handleSendMessage } = useMessageSending({
    message,
    attachedFiles,
    isVoiceMessageReady: false,
    isUploading,
    isSending,
    setIsSending,
    setMessage,
    setAttachedFiles,
    uploadFile,
    resetUploadState,
    onSendMessage
  });

  const { autoResizeTextarea } = useTextareaResize(textareaRef);

  const handleKeyDown = async (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      await handleSendMessage();
      textareaRef.current?.focus();
    }
  };

  const handleEmojiClick = (emoji) => {
    setMessage(prev => prev + emoji.native);
    textareaRef.current?.focus();
  };

  const askForCollage = () => {
    if (attachedFiles.length > 1 && attachedFiles.every(file => file.type.startsWith('image/'))) {
      toast.info("Create a collage?", {
        description: "Would you like to send these images as a collage?",
        action: {
          label: "Yes",
          onClick: () => {
            setCollageImages([...attachedFiles]);
            setShowCollageDialog(true);
          },
        },
        cancel: {
          label: "No",
          onClick: () => {},
        },
        duration: 5000,
      });
    }
  };

  useEffect(() => {
    if (attachedFiles.length > 1) {
      askForCollage();
    }
  }, [attachedFiles.length]);

  const handleCreateCollage = async () => {
    if (collageImages.length < 2) {
      toast.error("Need at least 2 images for collage");
      return;
    }

    setIsSending(true);
    try {
      const fileUrls = await Promise.all(
        collageImages.map(file => uploadFile(file)).filter(Boolean)
      );
      if (fileUrls.length !== collageImages.length) {
        throw new Error('Some files failed to upload');
      }

      const urlParam = fileUrls.map(url => encodeURIComponent(url)).join(',');

      const response = await fetch(`/api/collage?urls=${urlParam}&background=${collageBackground}`);
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || 'Failed to create collage');
      }

      const collageBlob = await response.blob();
      const collageFile = new File([collageBlob], 'collage.png', { type: 'image/png' });

      setAttachedFiles([collageFile]);
      setShowCollageDialog(false);
      setCollageImages([]);
      toast.success("Collage created successfully!");
    } catch (error) {
      toast.error("Failed to create collage", { 
        description: error.message || "Please try again" 
      });
    } finally {
      setIsSending(false);
    }
  };

  const handleFileSelect = (files) => {
    const validFiles = files.filter(file => {
      if (file.size > 10 * 1024 * 1024) {
        toast.error("File too large", { description: `${file.name} exceeds 10MB limit` });
        return false;
      }
      return true;
    });

    if (attachedFiles.length + validFiles.length > 4) {
      toast.error("Too many files", { description: "Maximum 4 files allowed" });
      const remainingSlots = 4 - attachedFiles.length;
      if (remainingSlots > 0) {
        setAttachedFiles(prev => [...prev, ...validFiles.slice(0, remainingSlots)]);
      }
    } else {
      setAttachedFiles(prev => [...prev, ...validFiles]);
    }
  };

  const handleCollageFileSelect = (files) => {
    const validImageFiles = files.filter(file => {
      if (!file.type.startsWith('image/')) {
        toast.error("Invalid file type", { description: `${file.name} is not an image` });
        return false;
      }
      if (file.size > 10 * 1024 * 1024) {
        toast.error("File too large", { description: `${file.name} exceeds 10MB limit` });
        return false;
      }
      return true;
    });

    if (collageImages.length + validImageFiles.length > 4) {
      toast.error("Too many images", { description: "Maximum 4 images allowed for collage" });
      const remainingSlots = 4 - collageImages.length;
      if (remainingSlots > 0) {
        setCollageImages(prev => [...prev, ...validImageFiles.slice(0, remainingSlots)]);
      }
    } else {
      setCollageImages(prev => [...prev, ...validImageFiles]);
    }
  };

  const removeAttachedFile = (index) => {
    setAttachedFiles(prev => prev.filter((_, i) => i !== index));
  };

  const removeCollageImage = (index) => {
    setCollageImages(prev => prev.filter((_, i) => i !== index));
  };

  const showSendButton = message.trim() || attachedFiles.length > 0;

  return (
    <div className="absolute w-full bottom-0 p-3 border-t bg-background">
      <Toaster position="bottom-center" className="select-none" />
      
      {attachedFiles.length > 0 && (
        <FileAttachment
          files={attachedFiles}
          onRemove={removeAttachedFile}
        />
      )}

      <ProgressIndicator 
        isUploading={isUploading}
        isSending={isSending}
        uploadProgress={uploadProgress}
      />

      <div className="flex items-start gap-2">
        <FileUploadMenu 
          fileInputRef={fileInputRef}
          onFileSelect={handleFileSelect}
        />

        <div className="relative flex-1">
          <Textarea
            ref={textareaRef}
            placeholder={`Message ${activeChat?.name || 'Chat'}`}
            className="pr-20 min-h-8 max-h-40 resize-none"
            value={message}
            onChange={(e) => {
              setMessage(e.target.value);
              autoResizeTextarea();
            }}
            onKeyDown={handleKeyDown}
            disabled={isSending}
            rows={1}
            autoFocus
          />
          
          <ActionButtons
            isSending={isSending}
            onEmojiClick={handleEmojiClick}
            onAttachClick={() => fileInputRef.current?.click()}
          />
        </div>

        {showSendButton && (
          <Button
            size="icon"
            className="rounded-full mt-1"
            onClick={handleSendMessage}
            disabled={isUploading || isSending}
          >
            <Send size={18} />
          </Button>
        )}
      </div>

      <Dialog open={showCollageDialog} onOpenChange={setShowCollageDialog}>
        <DialogContent className="max-w-md">
          <DialogHeader>
            <DialogTitle>Create Collage</DialogTitle>
          </DialogHeader>
          
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <Label htmlFor="background-toggle">Background</Label>
              <Switch
                id="background-toggle"
                checked={collageBackground}
                onCheckedChange={setCollageBackground}
              />
            </div>

            <div className="space-y-2">
              <Label>Images ({collageImages.length}/4)</Label>
              <div className="grid grid-cols-2 gap-2">
                {collageImages.map((file, index) => (
                  <div key={index} className="relative group">
                    <img
                      src={URL.createObjectURL(file)}
                      alt={`Collage image ${index + 1}`}
                      className="w-full h-20 object-cover rounded border"
                    />
                    <Button
                      size="sm"
                      variant="destructive"
                      className="absolute -top-2 -right-2 h-6 w-6 rounded-full p-0 opacity-0 group-hover:opacity-100 transition-opacity"
                      onClick={() => removeCollageImage(index)}
                    >
                      <X size={12} />
                    </Button>
                  </div>
                ))}
                
                {collageImages.length < 4 && (
                  <Button
                    variant="outline"
                    className="h-20 border-dashed flex items-center justify-center"
                    onClick={() => collageFileInputRef.current?.click()}
                  >
                    <Plus size={16} />
                  </Button>
                )}
              </div>
            </div>

            <input
              ref={collageFileInputRef}
              type="file"
              multiple
              accept="image/*"
              className="hidden"
              onChange={(e) => {
                if (e.target.files) {
                  handleCollageFileSelect(Array.from(e.target.files));
                  e.target.value = '';
                }
              }}
            />
          </div>

          <DialogFooter>
            <Button
              variant="outline"
              onClick={() => {
                setShowCollageDialog(false);
                setCollageImages([]);
              }}
            >
              Cancel
            </Button>
            <Button
              onClick={handleCreateCollage}
              disabled={collageImages.length < 2 || isSending}
            >
              {isSending ? "Creating..." : "Create Collage"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}