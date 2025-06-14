import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { 
  AlertCircle, 
  Download, 
  FileIcon,
  Loader2
} from "lucide-react";
import { cn } from "@/lib/utils";
import { RestrictedMarkdown } from "@/lib/md";
import ImageViewer from "@/components/others/image-viewer";
import CustomAudioPlayer from "@/components/others/custom-audio-player";
import { 
  FileTypeIcon, 
  getFileName, 
  getFileExtension, 
  isImageFile, 
  isAudioFile, 
  isVideoFile 
} from "@/lib/file";
import { useState, useEffect } from "react";

export default function Message({ 
  message, 
  isCurrentUser, 
  sender, 
  session,
  filePermissions,
  loadingFiles
}) {
  const [realFileName, setRealFileName] = useState(null);
  const [loadingFileName, setLoadingFileName] = useState(false);

  const timestamp = new Date(message.createdAt).toLocaleTimeString([], { 
    hour: '2-digit', 
    minute: '2-digit' 
  });

  useEffect(() => {
    if (message.fileUrl && filePermissions[message.fileUrl]) {
      fetchRealFileName();
    }
  }, [message.fileUrl, filePermissions]);

  const fetchRealFileName = async () => {
    if (loadingFileName || realFileName) return;
    
    setLoadingFileName(true);
    try {
      const urlParts = message.fileUrl.split('/');
      const userId = urlParts[urlParts.length - 2];
      const secureFilename = urlParts[urlParts.length - 1];

      const response = await fetch(`/api/file-info/${userId}/${secureFilename}`);
      if (response.ok) {
        const data = await response.json();
        setRealFileName(data.originalName);
      } else {
        setRealFileName(getFileName(message.fileUrl));

      }
    } catch (error) {
      console.error('Failed to fetch original filename:', error);
      setRealFileName(getFileName(message.fileUrl));
    } finally {
      setLoadingFileName(false);
    }
  };

  const handleDownload = async () => {
    try {
      const downloadUrl = `${message.fileUrl}${message.fileUrl.includes('?') ? '&' : '?'}download=true`;
      const response = await fetch(downloadUrl);
      
      if (!response.ok) {
        throw new Error('Download failed');
      }

      const blob = await response.blob();
      const url = window.URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      
      link.download = realFileName || getFileName(message.fileUrl);
      
      link.click();
      window.URL.revokeObjectURL(url);
    } catch (error) {
      console.error('Download failed:', error);
      const link = document.createElement('a');
      link.href = message.fileUrl;
      link.download = realFileName || getFileName(message.fileUrl);
      link.click();
    }
  };

  if (message.fileUrl && isAudioFile(message.fileUrl) && filePermissions[message.fileUrl]) {
    return (
      <div className={`flex ${isCurrentUser ? "justify-start" : "justify-end"} gap-3 mb-6`}>
        {isCurrentUser && (
          <Avatar className="h-10 w-10 mt-1">
            <AvatarImage src={session?.user?.image} alt={session?.user?.name || "User"} />
            <AvatarFallback className="bg-primary text-primary-foreground">
              {session?.user?.name?.charAt(0) || 'U'}
            </AvatarFallback>
          </Avatar>
        )}
        
        <CustomAudioPlayer 
          src={message.fileUrl} 
          isCurrentUser={isCurrentUser}
          timestamp={timestamp}
          senderName={!isCurrentUser ? sender.name : null}
          onDownload={handleDownload}
          realFileName={realFileName}
        />
        
        {!isCurrentUser && (
          <Avatar className="h-10 w-10 mt-1">
            <AvatarImage src={sender.image} alt={sender.name || "User"} />
            <AvatarFallback className="bg-muted-foreground text-muted-foreground-foreground">
              {sender.name?.charAt(0) || 'U'}
            </AvatarFallback>
          </Avatar>
        )}
      </div>
    );
  }

  return (
    <div className={`flex ${isCurrentUser ? "justify-start" : "justify-end"} gap-3 mb-4`}>
      {isCurrentUser && (
        <Avatar className="h-10 w-10 mt-1">
          <AvatarImage src={session?.user?.image} alt={session?.user?.name || "User"} />
          <AvatarFallback className="bg-primary text-primary-foreground">
            {session?.user?.name?.charAt(0) || 'U'}
          </AvatarFallback>
        </Avatar>
      )}
      
      <div className={`max-w-[75%] ${isCurrentUser ? "mr-1" : ""}`}>
        <div className="flex items-baseline gap-2 mb-1 justify-center">
          {!isCurrentUser && (
            <p className="text-sm font-medium text-foreground">
              {sender.name || 'Unknown User'}
            </p>
          )}
          <span className="text-xs text-muted-foreground">
            {timestamp}
          </span>
        </div>
        
        <div className="flex justify-center">
          {message.content && 
           message.content !== 'File attachment' && (
            <div className="rounded-xl px-4 py-3 max-w-lg break-words bg-background border text-foreground message">
              <RestrictedMarkdown content={message.content} />
            </div>
          )}
          
          {message.fileUrl && !isAudioFile(message.fileUrl) && (
            <div className={cn(
              "flex justify-center",
              message.content && 
              message.content !== 'File attachment' ? "mt-2" : ""
            )}>
              {loadingFiles[message.fileUrl] ? (
                <div className="rounded-xl p-4 max-w-sm flex items-center gap-2 bg-muted/40 border border-muted">
                  <Loader2 className="w-4 h-4 animate-spin" />
                  <span className="text-sm text-muted-foreground">Checking file access...</span>
                </div>
              ) : filePermissions[message.fileUrl] ? (
                <>
                  {isImageFile(message.fileUrl) ? (
                    <ImageViewer 
                      src={message.fileUrl} 
                      alt="Shared image"
                      isCurrentUser={isCurrentUser}
                      originalName={realFileName}
                    />
                  ) : isVideoFile(message.fileUrl) ? (
                    <div className="aspect-video w-full max-w-md rounded-lg overflow-hidden bg-black relative group">
                      <video 
                        controls
                        className="w-full h-full object-contain"
                        onError={(e) => {
                          console.error("Video playback error:", e);
                        }}
                      >
                        <source src={message.fileUrl} type="video/mp4" />
                        Your browser does not support the video tag.
                      </video>
                      
                      <div className="absolute top-2 right-2 opacity-0 group-hover:opacity-100 transition-opacity">
                        <Button
                          variant="secondary"
                          size="sm"
                          className="bg-black/80 text-white hover:bg-black/90 shadow-lg"
                          onClick={handleDownload}
                          title={`Download ${realFileName || 'video file'}`}
                        >
                          <Download className="h-4 w-4" />
                        </Button>
                      </div>
                    </div>
                  ) : (
                    <div className="rounded-xl p-4 max-w-sm bg-muted/60 border border-muted">
                      <div className="flex items-center gap-3">
                        <FileTypeIcon url={message.fileUrl} className="text-muted-foreground" />
                        <div className="flex-1 min-w-0">
                          <p className="text-sm font-medium truncate text-foreground">
                            {loadingFileName ? (
                              <span className="flex items-center gap-2">
                                <Loader2 className="w-3 h-3 animate-spin" />
                                Loading filename...
                              </span>
                            ) : (
                              realFileName || getFileName(message.fileUrl)
                            )}
                          </p>
                          <p className="text-xs text-muted-foreground">
                            {getFileExtension(message.fileUrl).toUpperCase()} file
                          </p>
                        </div>
                        <div className="flex gap-1">
                          <Button
                            variant="ghost"
                            size="sm"
                            className="h-8 w-8"
                            onClick={() => window.open(message.fileUrl, '_blank')}
                            title="Open file"
                          >
                            <FileIcon className="h-4 w-4" />
                          </Button>
                          <Button
                            variant="ghost"
                            size="sm"
                            className="h-8 w-8"
                            onClick={handleDownload}
                            title={`Download ${realFileName || getFileName(message.fileUrl)}`}
                            disabled={loadingFileName}
                          >
                            {loadingFileName ? (
                              <Loader2 className="h-4 w-4 animate-spin" />
                            ) : (
                              <Download className="h-4 w-4" />
                            )}
                          </Button>
                        </div>
                      </div>
                    </div>
                  )}
                </>
              ) : (
                <div className="rounded-xl p-4 max-w-sm bg-muted/40 border border-muted">
                  <div className="flex items-center gap-2 text-sm text-muted-foreground">
                    <AlertCircle className="w-4 h-4 flex-shrink-0" />
                    <span>File attachment not accessible</span>
                  </div>
                </div>
              )}
            </div>
          )}
        </div>
        
        {message.reactions && message.reactions.length > 0 && (
          <div className="flex flex-wrap gap-1 mt-2 justify-end">
            {message.reactions.map((reaction, idx) => (
              <Badge key={idx} variant="secondary" className="text-xs">
                {reaction.emoji} {reaction.count}
              </Badge>
            ))}
          </div>
        )}
      </div>
      
      {!isCurrentUser && (
        <Avatar className="h-10 w-10 mt-1">
          <AvatarImage src={sender.image} alt={sender.name || "User"} />
          <AvatarFallback className="bg-muted-foreground text-muted-foreground-foreground">
            {sender.name?.charAt(0) || 'U'}
          </AvatarFallback>
        </Avatar>
      )}
    </div>
  );
}