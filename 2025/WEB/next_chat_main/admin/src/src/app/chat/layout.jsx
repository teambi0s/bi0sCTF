"use client";

import ChatLayout from "@/components/layouts/chat-layout";
import { ChatProvider } from "@/contexts/chat-context";
import { SessionProvider } from "next-auth/react";

export default function Layout() {
  return (
    <SessionProvider >
      <ChatProvider>
        <ChatLayout />
      </ChatProvider>
    </SessionProvider>
  );
}