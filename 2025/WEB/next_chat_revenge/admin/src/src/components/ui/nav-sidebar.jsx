"use client";

import { useRouter } from "next/navigation";
import { signOut } from "next-auth/react";
import { 
  MessageSquare, 
  Users, 
  Settings, 
  LogOut, 
  HelpCircle, 
  Bell
} from "lucide-react";
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "@/components/ui/tooltip";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import Image from "next/image";

export default function NavSidebar({ activeTab, setActiveTab, session }) {
  const router = useRouter();
  
  const navItems = [
    { id: "chats", icon: MessageSquare, label: "Chats", notifications: 3 },
    { id: "notifications", icon: Bell, label: "Notifications", notifications: 5 },
    { id: "settings", icon: Settings, label: "Settings" }
  ];
  
  return (
    <div className="w-16 border-r flex flex-col items-center justify-between bg-background shadow-sm py-4">
      <div className="flex flex-col items-center space-y-4">
        <div className="w-10 h-10 bg-primary rounded-full flex items-center justify-center text-primary-foreground font-bold text-lg mb-6">
          C
        </div>
        
        <TooltipProvider delayDuration={300}>
          {navItems.map((item) => (
            <Tooltip key={item.id}>
              <TooltipTrigger asChild>
                <Button
                  variant={activeTab === item.id ? "secondary" : "ghost"}
                  size="icon"
                  className="relative"
                  onClick={() => setActiveTab(item.id)}
                >
                  <item.icon size={20} />
                  {item.notifications && (
                    <Badge 
                      className="absolute -top-1 -right-1 h-5 w-5 flex items-center justify-center p-0"
                    >
                      {item.notifications}
                    </Badge>
                  )}
                </Button>
              </TooltipTrigger>
              <TooltipContent side="right">
                {item.label}
              </TooltipContent>
            </Tooltip>
          ))}
        </TooltipProvider>
      </div>
      
      <div className="flex flex-col items-center space-y-4" >
        <TooltipProvider delayDuration={300}>
          <Tooltip>
            <TooltipTrigger asChild>
              <Button variant="ghost" size="icon">
                <HelpCircle size={20} />
              </Button>
            </TooltipTrigger>
            <TooltipContent side="right">
              Help
            </TooltipContent>
          </Tooltip>
        
          <Tooltip>
            <TooltipTrigger asChild>
              <div>
                <DropdownMenu>
                  <DropdownMenuTrigger asChild>
                  <Avatar className="h-9 w-9 cursor-pointer border-2">
                    {session?.user?.image ? (
                      <Image
                        src={session.user.image}
                        alt={session.user.name || 'User'}
                        width={36}
                        height={36}
                        className="rounded-full"
                        onError={(e) => {
                          e.target.style.display = 'none';
                        }}
                      />
                    ) : (
                      <div className="rounded-full bg-primary text-primary-foreground h-full w-full flex items-center justify-center">
                        {session?.user?.name?.charAt(0) || "?"}
                      </div>
                    )}
                  </Avatar>
                  </DropdownMenuTrigger>
                  <DropdownMenuContent align="start" className="w-56 relative">
                    <DropdownMenuLabel>
                      <div className="flex flex-col gap-0.5 space-y-1">
                        <p data-name={session?.user?.name} className="text-sm font-medium leading-none">{session?.user?.name || "User"}</p>
                        <p data-email={session?.user?.email} className="text-xs leading-none text-muted-foreground">
                          {session?.user?.email || "user@example.com"}
                        </p>
                        <p data-id={session?.user?.id} className="text-xs leading-none text-muted-foreground">
                          @{session?.user?.id || "Unknown"}
                        </p>
                      </div>
                    </DropdownMenuLabel>
                    <DropdownMenuSeparator />
                    <DropdownMenuItem onClick={() => router.push("/settings/profile")}>
                      Profile
                    </DropdownMenuItem>
                    <DropdownMenuItem onClick={() => router.push("/settings")}>
                      Settings
                    </DropdownMenuItem>
                    <DropdownMenuSeparator />
                    <DropdownMenuItem 
                      className="text-red-500 focus:text-red-500" 
                      onClick={() => signOut({ callbackUrl: "/auth/login" })}
                    >
                      <LogOut className="mr-2 h-4 w-4" />
                      <span>Log out</span>
                    </DropdownMenuItem>
                  </DropdownMenuContent>
                </DropdownMenu>
              </div>
            </TooltipTrigger>
            <TooltipContent side="right">
              Account
            </TooltipContent>
          </Tooltip>
        </TooltipProvider>
      </div>
    </div>
  );
}