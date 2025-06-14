"use client";

import { MenuIcon, MessageSquareWarning, CheckCircle, AlertTriangle, XCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "@/components/ui/tooltip";
import { toast } from "sonner";

export default function ChatHeader({ 
  activeChat, 
  participants, 
  userEmail
}) {
  const handleReport = async () => {
    const loadingToast = toast.loading("Reporting chat...");
    
    try {
      const response = await fetch("/api/report", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ chatId: activeChat.id, userEmail }),
      });
      
      const result = await response.json();
      
      toast.dismiss(loadingToast);
      
      if (!result.success) {
        toast.error(`Failed: ${result.error}`, {
          icon: <XCircle size={18} className="text-red-500" />
        });
        return;
      }

      if (result.abusive) {
        toast.success(`The chat was found to be abusive; actions will be taken. ${result.participants.sender}:${result.participants.receiver}`, {
          icon: <AlertTriangle size={18} className="text-yellow-500" />
        });
      } else {
        toast.success("The chat was found to be respectful; no action will be taken.", {
          icon: <CheckCircle size={18} className="text-green-500" />
        });
      }
    } catch (error) {
      toast.dismiss(loadingToast);
      
      toast.error("Error reporting chat.", {
        icon: <XCircle size={18} className="text-red-500" />
      });
    }
  };

  return (
    <header className="h-16 border-b flex items-center justify-between px-4 bg-background">
      <div className="flex items-center space-x-3">
        <Avatar className={`h-9 w-9 ${activeChat.color} text-white`}>
          <AvatarFallback className={`${activeChat.color} text-white`}>
            {activeChat.initials}
          </AvatarFallback>
        </Avatar>

        <div>
          <h2 className="font-medium text-base">{activeChat.name}</h2>
            <div className="flex items-center space-x-1">
              <div
                className={`w-2 h-2 rounded-full ${
                  participants[0]?.status.toLowerCase() === "online"
                    ? "bg-green-500"
                    : "bg-gray-400"
                }`}
              ></div>
              <span className="text-xs text-muted-foreground">
                {participants[0]?.status.toLowerCase() || "offline"}
              </span>
            </div>
        </div>
      </div>

      <div className="flex items-center space-x-1">
        <TooltipProvider>
          <Tooltip>
            <TooltipTrigger asChild>
              <Button 
                variant="ghost" 
                size="icon" 
                className="hidden sm:flex"
                onClick={handleReport}
              >
                <MessageSquareWarning size={18} />
              </Button>
            </TooltipTrigger>
            <TooltipContent>Report Chat</TooltipContent>
          </Tooltip>
          
          <Tooltip>
            <TooltipTrigger asChild>
              <Button variant="ghost" size="icon" className="md:hidden">
                <MenuIcon size={18} />
              </Button>
            </TooltipTrigger>
            <TooltipContent>Menu</TooltipContent>
          </Tooltip>
        </TooltipProvider>
      </div>
    </header>
  );
}