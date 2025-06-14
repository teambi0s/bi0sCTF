import { Paperclip } from "lucide-react";
import { Button } from "@/components/ui/button";
import EmojiPicker from "./emoji-picker";

export default function ActionButtons({ 
  isSending, 
  onEmojiClick, 
  onAttachClick 
}) {
  return (
    <div className="absolute right-4 bottom-1 flex items-center gap-1">
      <EmojiPicker 
        onEmojiClick={onEmojiClick}
        disabled={isSending}
      />
      <Button
        variant="ghost"
        size="icon"
        className="h-8 w-8 rounded-full"
        onClick={onAttachClick}
        disabled={isSending}
      >
        <Paperclip size={18} />
      </Button>
    </div>
  );
}