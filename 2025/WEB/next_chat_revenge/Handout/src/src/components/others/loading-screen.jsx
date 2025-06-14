"use client";

export default function LoadingScreen() {
  return (
    <div className="fixed inset-0 flex items-center justify-center bg-background">
      <div className="flex flex-col items-center">
        <div className="w-16 h-16 relative">
          <div className="absolute inset-0 flex items-center justify-center">
            <div className="w-12 h-12 bg-primary rounded-full opacity-20 animate-ping"></div>
          </div>
          <div className="absolute inset-0 flex items-center justify-center">
            <div className="w-8 h-8 bg-primary rounded-full"></div>
          </div>
        </div>
        <h2 className="text-xl font-semibold mt-4">Loading</h2>
        <p className="text-sm text-muted-foreground mt-1">Please wait...</p>
      </div>
    </div>
  );
}