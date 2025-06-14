"use client";

import { useEffect, useState } from 'react';
import { Search, User, Pin, PinOff, Trash2 } from 'lucide-react';
import { Input } from '@/components/ui/input';
import { ScrollArea } from '@/components/ui/scroll-area';
import { useChatContext } from '@/contexts/chat-context';
import { formatDistanceToNow } from 'date-fns';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Badge } from '@/components/ui/badge';
import NewChatButton from './new-chat-button';
import { useRouter } from 'next/navigation';

export default function ConversationSidebar({ conversations, activeEntityId, activeEntityType, setActiveChat }) {
  const router = useRouter();
  const { 
    searchQuery, 
    setSearchQuery 
  } = useChatContext();
  
  const [contextMenu, setContextMenu] = useState({
    isOpen: false,
    x: 0,
    y: 0,
    itemId: null,
    itemType: null
  });
  
  const allItems = conversations || [];

  useEffect(() => {
    if (contextMenu.isOpen) {
      const handleClickOutside = () => {
        setContextMenu(prev => ({ ...prev, isOpen: false }));
      };
      
      document.addEventListener("click", handleClickOutside);
      document.addEventListener("contextmenu", handleClickOutside);
      
      return () => {
        document.removeEventListener("click", handleClickOutside);
        document.removeEventListener("contextmenu", handleClickOutside);
      };
    }
  }, [contextMenu.isOpen]);

  const getFilteredItems = () => {
    if (!allItems || allItems.length === 0) return [];
    
    return allItems.filter(chat => {
      const name = chat?.name || '';
      return name.toLowerCase().includes(searchQuery.toLowerCase());
    });
  };
  
  const filteredItems = getFilteredItems();
  
  const getInitials = (name) => {
    if (!name) return '?';
    return name.split(' ').map(n => n[0]).join('').toUpperCase();
  };
  
  const handleChatClick = (item) => {
    setActiveChat(item.id, item.type);
    router.push(`/chat/${item.id}`, { scroll: false });
  };
  
  const handleContextMenu = (e, item) => {
    e.preventDefault();
    e.stopPropagation();
    
    document.dispatchEvent(new MouseEvent("click"));
    
    const x = Math.min(
      e.clientX,
      window.innerWidth - 200
    );
    
    const y = Math.min(
      e.clientY,
      window.innerHeight - 250
    );
    
    setTimeout(() => {
      setContextMenu({
        isOpen: true,
        x,
        y,
        itemId: item.id,
        itemType: item.type
      });
    }, 10);
  };

  const closeContextMenu = () => {
    setContextMenu(prev => ({ ...prev, isOpen: false }));
  };

  const renderContextMenu = () => {
    if (!contextMenu.isOpen) return null;
    
    const item = allItems.find(
      chat => chat.id === contextMenu.itemId && chat.type === contextMenu.itemType
    );
    
    if (!item) return null;
    
    const menuItems = [
      { icon: User, label: "View Profile" },
      { icon: item.pinned ? PinOff : Pin, label: item.pinned ? "Unpin" : "Pin", 
        onClick: () => console.log(`${item.pinned ? 'Unpinning' : 'Pinning'} ${item.name || 'chat'}`) },
      { icon: Trash2, label: "Delete", 
        onClick: () => console.log(`Deleting ${item.name || 'chat'}`), danger: true },
    ];
    
    return (
      <div 
        className="fixed bg-popover border rounded-md shadow-md py-1 z-50"
        style={{ top: contextMenu.y, left: contextMenu.x }}
        onClick={(e) => e.stopPropagation()}
        onContextMenu={(e) => {
          e.preventDefault();
          e.stopPropagation();
        }}
      >
        {menuItems.map((menuItem, index) => (
          <button
            key={index}
            className={`flex items-center w-full px-3 py-2 text-sm hover:bg-accent ${menuItem.danger ? 'text-red-500 hover:text-red-600' : 'text-foreground'}`}
            onClick={(e) => {
              e.stopPropagation();
              if (menuItem.onClick) menuItem.onClick();
              closeContextMenu();
            }}
          >
            <menuItem.icon size={16} className="mr-2" />
            {menuItem.label}
          </button>
        ))}
      </div>
    );
  };
  
  const renderItem = (item) => {
    const isActive = activeEntityId === item.id && activeEntityType === item.type;
    const timestamp = item.timestamp ? formatDistanceToNow(new Date(item.timestamp), { addSuffix: true }) : '';
    
    return (
      <div 
        key={`${item.type}-${item.id}`}
        className={`flex relative items-center space-x-3 p-3 rounded-md cursor-pointer ${
          isActive ? 'bg-muted' : 'hover:bg-muted/50'
        }`}
        onClick={() => contextMenu.isOpen ? null : handleChatClick(item)}
        onContextMenu={(e) => handleContextMenu(e, item)}
      >
        <Avatar className="h-10 w-10">
          <AvatarImage 
            src={item?.image || ''} 
            alt={item.name || 'Chat'} 
          />
          <AvatarFallback>
            {getInitials(item?.name || 'User')}
          </AvatarFallback>
        </Avatar>
        
        <div className="flex-1 min-w-0">
          <div className="flex justify-between items-start">
            <p className="text-sm font-medium truncate">
              {item?.name || 'User'}
            </p>
          </div>
        </div>
        
        {item.unread > 0 && (
          <Badge variant="default" className="ml-auto">
            {item.unread}
          </Badge>
        )}
      </div>
    );
  };
  
  return (
    <div className="w-72 border-r flex flex-col h-full">
      <div className="p-4 border-b flex flex-col space-y-4">
        <div className="flex items-center justify-between">
          <h2 className="text-lg font-semibold">Messages</h2>
          <div className="flex items-center space-x-1">
            <NewChatButton />
          </div>
        </div>
        
        <div className="relative">
          <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Search messages..."
            className="pl-8"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
        </div>
      </div>
      
      <ScrollArea className="flex-1">
        <div className="p-2 space-y-1">
          {filteredItems.length > 0 ? (
            filteredItems.map(renderItem)
          ) : (
            <div className="flex flex-col items-center justify-center h-32 text-center p-4">
              <p className="text-sm text-muted-foreground">
                {searchQuery 
                  ? 'No matches found' 
                  : 'No conversations found'}
              </p>
              {!searchQuery && (
                <p className="text-xs text-muted-foreground mt-1">
                  Start a new conversation by clicking the + button
                </p>
              )}
            </div>
          )}
        </div>
      </ScrollArea>
      
      {renderContextMenu()}
    </div>
  );
}