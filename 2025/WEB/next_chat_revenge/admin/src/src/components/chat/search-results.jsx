"use client";

import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { ScrollArea } from '@/components/ui/scroll-area';

export function SearchResults({ results, onUserSelect }) {
  return (
    <ScrollArea className="h-[200px] w-full border rounded-md p-2">
      {results.map((user) => (
        <div 
          key={user.id}
          className="flex items-center space-x-3 p-2 hover:bg-muted rounded-md cursor-pointer"
          onClick={() => onUserSelect(user)}
        >
          <Avatar className="h-8 w-8">
            <AvatarImage src={user.image} />
            <AvatarFallback>{user.name?.charAt(0) || '?'}</AvatarFallback>
          </Avatar>
          <div>
            <p className="text-sm font-medium">{user.name}</p>
            <p className="text-xs text-muted-foreground">{user.email}</p>
          </div>
        </div>
      ))}
    </ScrollArea>
  );
}