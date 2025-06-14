import { useState } from "react";
import { PlusCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { selectFileType } from "@/lib/file";

export default function FileUploadMenu({ fileInputRef, onFileSelect }) {
  const [showPlusMenu, setShowPlusMenu] = useState(false);

  const handleFileSelect = (e) => {
    const files = Array.from(e.target.files);
    if (files.length === 0) return;

    setShowPlusMenu(false);
    onFileSelect(files);

    if (fileInputRef.current) {
      fileInputRef.current.value = "";
    }
  };

  const handleFileTypeClick = (type) => {
    selectFileType(type, fileInputRef);
    setShowPlusMenu(false);
  };

  return (
    <>
      <Popover open={showPlusMenu} onOpenChange={setShowPlusMenu}>
        <PopoverTrigger asChild>
          <Button variant="ghost" size="icon" className="rounded-full mt-1">
            <PlusCircle size={18} />
          </Button>
        </PopoverTrigger>
        <PopoverContent side="top" align="start" className="w-64 p-2">
          <div className="grid grid-cols-2 gap-2">
            {['photo', 'document', 'video', 'audio'].map(type => (
              <Button
                key={type}
                variant="outline"
                className="flex flex-col h-auto py-2 px-0"
                onClick={() => handleFileTypeClick(type)}
              >
                {selectFileType.getIcon(type, 18)}
                <span className="text-xs">{type.charAt(0).toUpperCase() + type.slice(1)}</span>
              </Button>
            ))}
          </div>
        </PopoverContent>
      </Popover>

      <input
        ref={fileInputRef}
        type="file"
        className="hidden"
        onChange={handleFileSelect}
        multiple
      />
    </>
  );
}