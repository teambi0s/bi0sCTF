import { 
  FileIcon,
  File as FileEmoji,
  FileText,
  Archive,
  Video,
  Image as ImageIcon,
  Volume2,
  Music
} from "lucide-react";
import { cn } from "@/lib/utils";

export const getFileExtension = (url) => {
  if (!url) return '';
  const parts = url.split('.');
  return parts.length > 1 ? parts[parts.length - 1].toLowerCase() : '';
};

export const getFileName = (url) => {
  if (!url) return 'Unknown file';
  const parts = url.split('/');
  return decodeURIComponent(parts[parts.length - 1]);
};

export const isImageFile = (url) => {
  const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'];
  const ext = getFileExtension(url);
  return imageExtensions.includes(ext);
};

export const isAudioFile = (url) => {
  const audioExtensions = ['webm', 'ogg', 'wav', 'mp3'];
  const ext = getFileExtension(url);
  return audioExtensions.includes(ext);
};

export const isVideoFile = (url) => {
  const videoExtensions = ['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm'];
  const ext = getFileExtension(url);
  return videoExtensions.includes(ext);
};

export const FileTypeIcon = ({ url, className }) => {
  const ext = getFileExtension(url);
  const iconProps = { className: cn("h-5 w-5", className) };

  if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'].includes(ext)) {
    return <ImageIcon {...iconProps} />;
  }
  if (['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm'].includes(ext)) {
    return <Video {...iconProps} />;
  }
  if (['mp3', 'wav', 'ogg', 'flac', 'aac'].includes(ext)) {
    return <Volume2 {...iconProps} />;
  }
  if (['pdf', 'doc', 'docx', 'txt', 'rtf'].includes(ext)) {
    return <FileText {...iconProps} />;
  }
  if (['zip', 'rar', '7z', 'tar', 'gz'].includes(ext)) {
    return <Archive {...iconProps} />;
  }
  return <FileIcon {...iconProps} />;
};

export const selectFileType = (type, fileInputRef) => {
  if (!fileInputRef.current) return;

  switch (type) {
    case 'photo':
      fileInputRef.current.accept = "image/*";
      break;
    case 'document':
      fileInputRef.current.accept = "application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document,text/plain";
      break;
    case 'video':
      fileInputRef.current.accept = "video/*";
      break;
    case 'audio':
      fileInputRef.current.accept = "audio/*";
      break;
    default:
      fileInputRef.current.accept = "image/*,application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document,text/plain,video/*,audio/*";
  }
  fileInputRef.current.click();
};

selectFileType.getIcon = (type, size) => {
  switch (type) {
    case 'photo': return <ImageIcon size={size} />;
    case 'document': return <FileEmoji size={size} />;
    case 'video': return <Video size={size} />;
    case 'audio': return <Music size={size} />;
    default: return <FileEmoji size={size} />;
  }
};