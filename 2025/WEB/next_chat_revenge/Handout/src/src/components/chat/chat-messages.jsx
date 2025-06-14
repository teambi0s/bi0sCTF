"use client";

import { useEffect, useRef } from "react";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Card, CardContent } from "@/components/ui/card";
import { useSession } from "next-auth/react";
import { useFilePermissions } from "@/hooks/use-file-permissions";
import Message from "./message";

export default function ChatMessages({ activeChat, messages, participants }) {
  const { data: session } = useSession();
  const scrollRef = useRef(null);
  const { filePermissions, loadingFiles } = useFilePermissions(messages);

  useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollIntoView({ behavior: 'smooth', block: 'end' });
    }
  }, [messages]);

  if (!activeChat) {
    return (
      <div className="flex flex-col items-center justify-center h-full p-6">
        <Card className="w-full max-w-md p-6 text-center">
          <CardContent className="pt-6">
            <p className="text-muted-foreground">Select a conversation to start chatting</p>
          </CardContent>
        </Card>
      </div>
    );
  }

  return (
    <ScrollArea className="flex-1 h-full p-4 space-y-4 bg-muted/20">
      <div className="w-full pb-20 space-y-6">
        {messages.length === 0 ? (
          <Card className="mx-auto max-w-md text-center">
            <CardContent className="py-8">
              <p className="text-muted-foreground">No messages yet. Start the conversation!</p>
            </CardContent>
          </Card>
        ) : (
          messages.map((message) => {
            const isCurrentUser = message.senderId === session?.user?.id;
            const sender = isCurrentUser ? session?.user : message.sender || {};
            
            return (
              <Message
                key={message.id}
                message={message}
                isCurrentUser={isCurrentUser}
                sender={sender}
                session={session}
                filePermissions={filePermissions}
                loadingFiles={loadingFiles}
              />
            );
          })
        )}
        <div ref={scrollRef} />
      </div>
    </ScrollArea>
  );
}