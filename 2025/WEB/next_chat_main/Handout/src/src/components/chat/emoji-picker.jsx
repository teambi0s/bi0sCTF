import { useState, useEffect, useMemo } from "react";
import { Smile } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { useTheme } from 'next-themes';
import data from '@emoji-mart/data';
import Picker from '@emoji-mart/react';

export default function EmojiPicker({ onEmojiClick, disabled = false }) {
  const [showEmojiPicker, setShowEmojiPicker] = useState(false);
  const { theme, resolvedTheme } = useTheme();

  const pickerTheme = useMemo(() => {
    if (theme === 'system') {
      return resolvedTheme === 'dark' ? 'dark' : 'light';
    }
    return theme;
  }, [theme, resolvedTheme]);

  const handleEmojiSelect = (emoji) => {
    onEmojiClick(emoji);
    setShowEmojiPicker(false);
  };

  return (
    <Popover open={showEmojiPicker} onOpenChange={setShowEmojiPicker}>
      <PopoverTrigger asChild>
        <Button 
          variant="ghost" 
          size="icon" 
          className="h-8 w-8 rounded-full"
          disabled={disabled}
        >
          <Smile size={18} />
        </Button>
      </PopoverTrigger>
      <PopoverContent side="top" align="end" className="w-auto p-0 border-none" sideOffset={5}>
        <Picker
          data={data}
          onEmojiSelect={handleEmojiSelect}
          theme={pickerTheme}
          skinTonePosition="none"
          previewPosition="none"
          set="native"
          emojiSize={20}
          emojiButtonSize={28}
          maxFrequentRows={0}
        />
      </PopoverContent>
    </Popover>
  );
}