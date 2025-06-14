"use client";

import { useState } from 'react';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { SearchResults } from './search-results';
import { searchUsers } from '@/services/api-service';
import { useSession } from 'next-auth/react';

export function UserSearch({ onUserSelect, selectedUser }) {
  const [searchQuery, setSearchQuery] = useState('');
  const [searchResults, setSearchResults] = useState([]);
  const { data: session } = useSession();

  const handleSearch = async (query) => {
    setSearchQuery(query);
    if (query.length < 2) {
      setSearchResults([]);
      return;
    }

    try {
      const results = await searchUsers(query);
      const filteredResults = results.filter(user => 
        user.id !== session?.user?.id
      );
      setSearchResults(filteredResults);
    } catch (error) {
      console.error('Error searching users:', error);
    }
  };

  const handleUserSelect = (user) => {
    onUserSelect(user);
    setSearchQuery('');
    setSearchResults([]);
  };

  return (
    <div className="space-y-2">
      <Label htmlFor="user-search">Search User</Label>
      <Input
        id="user-search"
        placeholder="Search by name or email"
        value={searchQuery}
        onChange={(e) => handleSearch(e.target.value)}
      />
      
      {searchResults.length > 0 && !selectedUser && (
        <SearchResults 
          results={searchResults}
          onUserSelect={handleUserSelect}
        />
      )}
    </div>
  );
}