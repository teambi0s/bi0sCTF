"use client";

import { Edit, Bell, PlusCircle, Image } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";

const DetailsSidebar = ({ activeChat, activeEntityType, participants }) => {
  const getStatusColor = (status) => {
    switch(status.toLowerCase()) {
      case "online": return "bg-green-500";
      case "idle": return "bg-amber-500";
      case "dnd": return "bg-red-500";
      default: return "bg-gray-400";
    }
  };

  const onlineUsers = participants.filter(p => p.status.toLowerCase() === "online");
  const offlineUsers = participants.filter(p => p.status.toLowerCase() !== "online");
  const admin = participants.filter(p => p.role?.toLowerCase() === "admin");
  
  
  return (
    <aside className="w-64 border-l bg-background h-full">
      <div className="p-4 border-b">
        <h3 className="font-bold text-center">{activeEntityType === "group" ? "Group" : "Chat"} Details</h3>
      </div>

      <div className="p-4 border-b text-center">
        <Avatar className={`h-16 w-16 mb-2 mx-auto rounded-lg ${activeChat.color} text-white`}>
          <AvatarFallback className={`${activeChat.color} text-white`}>
            {activeChat.initials}
          </AvatarFallback>
        </Avatar>
        <h3 className="font-bold">{activeChat.name}</h3>
        {activeEntityType === "group" && <p className="text-sm text-muted-foreground mt-1">Created by {admin[0]?.name}</p>}
        
        <div className="flex justify-center gap-2 mt-3">
          {activeEntityType === "group" && 
            <Button variant="outline" size="sm" className="h-8 gap-1">
              <Edit size={14} />
              <span>Edit</span>
            </Button>
          }
          <Button variant="outline" size="sm" className="h-8 gap-1">
            <Bell size={14} />
            <span>Mute</span>
          </Button>
        </div>
      </div>

      {activeEntityType === "group" &&
        <ScrollArea className="h-80">
          <div className="p-4">
            <h3 className="font-medium mb-2 flex items-center justify-between">
              <span>Members · {participants.length}</span>
              <Button variant="ghost" size="sm" className="h-6 w-6 p-0">
                <PlusCircle size={14} />
              </Button>
            </h3>
            
            <Tabs defaultValue="online" className="mt-2">
              <TabsList className="grid w-full grid-cols-2">
                <TabsTrigger value="online">Online ({onlineUsers.length})</TabsTrigger>
                <TabsTrigger value="offline">Offline ({offlineUsers.length})</TabsTrigger>
              </TabsList>
              
              <TabsContent value="online" className="mt-2 space-y-2">
                {onlineUsers.map(user => (
                  <div key={user.id} className="flex items-center justify-between p-1 rounded-md hover:bg-muted">
                    <div className="flex items-center gap-2">
                      <Avatar className="h-8 w-8">
                        <AvatarFallback>
                          {user.name.charAt(0)}
                        </AvatarFallback>
                      </Avatar>
                      <div className="text-sm">
                        {user.name}
                        {user.role && (
                          <Badge variant="secondary" className="ml-1 font-normal text-xs">
                            {user.role.toLowerCase()}
                          </Badge>
                        )}
                      </div>
                    </div>
                    <div className={`w-2 h-2 rounded-full ${getStatusColor(user.status)}`}></div>
                  </div>
                ))}
              </TabsContent>
              
              <TabsContent value="offline" className="mt-2 space-y-2">
                {offlineUsers.map(user => (
                  <div key={user.id} className="flex items-center justify-between p-1 rounded-md hover:bg-muted">
                    <div className="flex items-center gap-2">
                      <Avatar className="h-8 w-8">
                        <AvatarFallback className="bg-muted">
                          {user.name.charAt(0)}
                        </AvatarFallback>
                      </Avatar>
                      <div className="text-sm text-muted-foreground">
                        {user.name}
                        {user.lastSeen && <div className="text-xs">{user.lastSeen}</div>}
                      </div>
                    </div>
                    <div className={`w-2 h-2 rounded-full ${getStatusColor(user.status)}`}></div>
                  </div>
                ))}
              </TabsContent>
            </Tabs>
          </div>
        </ScrollArea>
        
      }
      <div className={`p-4 ${activeEntityType === "group" ? "border-t" : ""}`}>
        <h3 className="font-medium mb-2">Files & Media</h3>
        <Card className="bg-muted/50">
          <CardContent className="text-center py-6">
            <Image size={36} className="mx-auto mb-2 opacity-50" />
            <p className="text-sm text-muted-foreground">No media shared yet</p>
          </CardContent>
        </Card>
      </div>
    </aside>
  );
};

export default DetailsSidebar;