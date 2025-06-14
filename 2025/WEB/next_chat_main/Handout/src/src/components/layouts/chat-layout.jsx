"use client";

import { useEffect, useState } from "react";
import { useSession } from "next-auth/react";
import { useChatContext } from "@/contexts/chat-context";
import { getConversationParticipants } from "@/services/api-service";
import NavSidebar from "@/components/navigation/nav-sidebar";
import ConversationSidebar from "@/components/chat/conversation-sidebar";
import ChatHeader from "@/components/chat/chat-header";
import ChatMessages from "@/components/chat/chat-messages";
import MessageInputBar from "@/components/chat/message-input-bar";
import LoadingScreen from "@/components/others/loading-screen";

export default function ChatLayout() {
  const { data: session, status } = useSession();
  const {
    conversations,
    messages,
    activeEntityId,
    activeEntityType,
    setActiveChat,
    getActiveEntity,
    sendMessage
  } = useChatContext();

  const [activeTab, setActiveTab] = useState("chats");
  const [participants, setParticipants] = useState([]);

  const activeChat = getActiveEntity();

  useEffect(() => {
    const fetchParticipants = async () => {
      if (!activeChat || activeEntityType !== "conversation") return;

      try {
        const data = await getConversationParticipants(activeChat.id);
        setParticipants(data);
      } catch (err) {
        console.error("Failed to fetch participants:", err);
        setParticipants([]);
      }
    };

    fetchParticipants();
  }, [activeChat, activeEntityType]);

  if (status === "loading") {
    return <LoadingScreen />;
  }

  return (
    <main 
      className="flex h-screen bg-background text-foreground overflow-hidden"
      onContextMenu={(e) => e.preventDefault()}
    >
      <NavSidebar 
        activeTab={activeTab} 
        setActiveTab={setActiveTab} 
        session={session} 
      />

      <ConversationSidebar 
        conversations={conversations.map(c => ({...c, type: 'conversation'}))}
        activeEntityId={activeEntityId}
        activeEntityType={activeEntityType}
        setActiveChat={setActiveChat}
      />

      <main className="flex-1 flex flex-col overflow-hidden">
        {activeChat ? (
          <>
            <ChatHeader 
              activeChat={activeChat} 
              activeEntityType={activeEntityType}
              participants={participants}
              userEmail={session?.user?.email}
            />

            <div className="flex flex-1 overflow-hidden">
              <section className="relative flex-1 flex flex-col overflow-hidden">
                <ChatMessages 
                  activeChat={activeChat} 
                  messages={messages} 
                  participants={participants} 
                />
                <MessageInputBar 
                  activeChat={activeChat} 
                  onSendMessage={sendMessage}
                />
              </section>
            </div>
          </>
        ) : 
          <div className="flex items-center text-foreground justify-center h-full">
            Select a chat to start a conversation.
          </div>
        }
      </main>
    </main>
  );
}