"use client";

import { useState } from 'react';
import { Plus } from 'lucide-react';
import { Button } from '@/components/ui/button';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';
import { UserSearch } from './user-search';
import { useRouter } from 'next/navigation';
import { SelectedUser } from './selected-user';
import { CreateConversationFooter } from './create-conversation-footer';
import { createConversation } from '@/services/api-service';

export default function NewChatButton() {
  const router = useRouter();
  const [isOpen, setIsOpen] = useState(false);
  const [selectedUser, setSelectedUser] = useState(null);
  const [isLoading, setIsLoading] = useState(false);

  const handleCreateConversation = async () => {
    if (!selectedUser) return;
    
    try {
      setIsLoading(true);
      const conversation = await createConversation(selectedUser.id);
      router.push(`/chat/${conversation.id}`, { scroll: false });
      resetForm();
      setIsOpen(false);
    } catch (error) {
      console.error('Error creating conversation:', error);
    } finally {
      setIsLoading(false);
      location.reload();
    }
  };

  const resetForm = () => {
    setSelectedUser(null);
  };

  return (
    <Dialog open={isOpen} onOpenChange={setIsOpen}>
      <DialogTrigger asChild>
        <Button 
          variant="ghost" 
          size="icon"
          className="rounded-full h-10 w-10 flex items-center justify-center"
          onClick={resetForm}
        >
          <Plus className="h-5 w-5" />
        </Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>New Conversation</DialogTitle>
        </DialogHeader>
        
        <div className="space-y-4 mt-4">
          <UserSearch 
            onUserSelect={setSelectedUser}
            selectedUser={selectedUser}
          />
          
          {selectedUser && (
            <SelectedUser 
              user={selectedUser}
              onClear={() => setSelectedUser(null)}
            />
          )}
          
          <CreateConversationFooter
            selectedUser={selectedUser}
            isLoading={isLoading}
            onCreateConversation={handleCreateConversation}
          />
        </div>
      </DialogContent>
    </Dialog>
  );
}