"use client";

import { Button } from '@/components/ui/button';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';

export function SelectedUser({ user, onClear }) {
  return (
    <div className="flex items-center space-x-3 p-2 bg-muted rounded-md">
      <Avatar className="h-8 w-8">
        <AvatarImage src={user.image} />
        <AvatarFallback>{user.name?.charAt(0) || '?'}</AvatarFallback>
      </Avatar>
      <div>
        <p className="text-sm font-medium">{user.name}</p>
        <p className="text-xs text-muted-foreground">{user.email}</p>
      </div>
      <Button 
        variant="ghost" 
        size="sm" 
        className="ml-auto"
        onClick={onClear}
      >
        Change
      </Button>
    </div>
  );
}