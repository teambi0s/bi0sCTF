"use client";

import { Button } from '@/components/ui/button';
import { DialogFooter } from '@/components/ui/dialog';

export function CreateConversationFooter({ selectedUser, isLoading, onCreateConversation }) {
  return (
    <DialogFooter className="mt-4">
      <Button 
        onClick={onCreateConversation} 
        disabled={!selectedUser || isLoading}
      >
        Start Conversation
      </Button>
    </DialogFooter>
  );
}