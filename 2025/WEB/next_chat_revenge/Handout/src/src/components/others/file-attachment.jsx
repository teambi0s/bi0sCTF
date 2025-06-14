import { Button } from "@/components/ui/button";
import { Image, Mic, Video, FileText, X } from "lucide-react";

export default function FileAttachment({ files, onRemove }) {
  return (
    <div className="mb-2 flex flex-wrap gap-2">
      {files.map((file, index) => (
        <div
          key={index}
          className="px-3 py-2 rounded-md flex items-center justify-between bg-muted"
        >
          <div className="flex items-center gap-2 text-sm">
            {file.type.startsWith('image/') ? (
              <Image size={16} />
            ) : file.type.startsWith('audio/') ? (
              <Mic size={16} />
            ) : file.type.startsWith('video/') ? (
              <Video size={16} />
            ) : (
              <FileText size={16} />
            )}
            <span className="truncate max-w-[200px]">
              {file.name}
            </span>
            <span className="text-xs text-muted-foreground">
              {(file.size / 1024).toFixed(1)} KB
            </span>
          </div>
          <Button
            variant="ghost"
            size="icon"
            className="h-6 w-6"
            onClick={() => onRemove(index)}
          >
            <X size={14} />
          </Button>
        </div>
      ))}
    </div>
  );
}