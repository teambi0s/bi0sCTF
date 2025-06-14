"use client";

import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Dialog, DialogClose, DialogContent, DialogTitle } from "@/components/ui/dialog";
import {
  Download,
  ZoomIn,
  ZoomOut,
  RotateCw,
  X,
  Info,
} from "lucide-react";

export default function ImageViewer({ src, alt, originalName }) {
  const [isOpen, setIsOpen] = useState(false);
  const [zoom, setZoom] = useState(1);
  const [rotation, setRotation] = useState(0);
  const [realFileName, setRealFileName] = useState(originalName || null);

  useEffect(() => {
    if (!originalName && src) {
      fetchOriginalFileName();
    }
  }, [src, originalName]);

  const fetchOriginalFileName = async () => {
    try {
      const urlParts = src.split('/');
      const userId = urlParts[urlParts.length - 2];
      const secureFilename = urlParts[urlParts.length - 1];

      const response = await fetch(`/api/file-info/${userId}/${secureFilename}`);
      if (response.ok) {
        const data = await response.json();
        setRealFileName(data.originalName);
      }
    } catch (error) {
      console.error('Failed to fetch original filename:', error);
      setRealFileName('image');
    }
  };

  const handleDownload = async () => {
    try {
      const downloadUrl = `${src}${src.includes('?') ? '&' : '?'}download=true`;
      const response = await fetch(downloadUrl);
      
      if (!response.ok) {
        throw new Error('Download failed');
      }

      const blob = await response.blob();
      const url = window.URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      
      link.download = realFileName || 'image';
      
      link.click();
      window.URL.revokeObjectURL(url);
    } catch (error) {
      console.error('Download failed:', error);
    }
  };

  const zoomIn = () => {
    setZoom((z) => Math.min(z + 0.25, 5));
  };

  const zoomOut = () => {
    setZoom((z) => Math.max(z - 0.25, 0.25));
  };

  const resetView = () => {
    setZoom(1);
    setRotation(0);
  };

  const rotate = () => {
    setRotation((r) => r + 90);
  };

  useEffect(() => {
    if (isOpen) {
      resetView();
    }
  }, [isOpen]);

  useEffect(() => {
    if (!isOpen) return;

    const handleKeyDown = (e) => {
      switch (e.key) {
        case 'Escape':
          setIsOpen(false);
          break;
        case '+':
        case '=':
          e.preventDefault();
          zoomIn();
          break;
        case '-':
          e.preventDefault();
          zoomOut();
          break;
        case 'r':
        case 'R':
          e.preventDefault();
          rotate();
          break;
        case '0':
          e.preventDefault();
          resetView();
          break;
      }
    };

    document.addEventListener('keydown', handleKeyDown);
    return () => document.removeEventListener('keydown', handleKeyDown);
  }, [isOpen]);

  return (
    <>
      <div className="relative group cursor-pointer" onClick={() => setIsOpen(true)}>
        <div className="aspect-[4/3] w-full max-w-sm overflow-hidden rounded-lg bg-muted/20">
          <img
            src={src}
            alt={alt || "Shared image"}
            className="w-full h-full object-cover transition-transform duration-200 group-hover:scale-105"
            onError={(e) => {
              e.target.onerror = null;
              e.target.style.display = 'none';
            }}
            loading="lazy"
          />
        </div>
        <div className="absolute inset-0 bg-black/0 group-hover:bg-black/20 transition-all duration-200 rounded-lg flex items-center justify-center opacity-0 group-hover:opacity-100">
          <div className="flex gap-2">
            <Button variant="secondary" size="sm" className="bg-white/90 text-black hover:bg-white shadow-lg">
              <ZoomIn className="h-4 w-4 mr-1" />
              View
            </Button>
            <Button
              variant="secondary"
              size="sm"
              className="bg-white/90 text-black hover:bg-white shadow-lg"
              onClick={(e) => {
                e.stopPropagation();
                handleDownload();
              }}
            >
              <Download className="h-4 w-4" />
            </Button>
          </div>
        </div>
      </div>

      <Dialog open={isOpen} onOpenChange={setIsOpen}>
        <DialogTitle className="sr-only">Image Viewer</DialogTitle>
        <DialogContent className="max-h-none w-full h-screen p-0 bg-black/95 border-0 rounded-none [&>button:last-child]:hidden">
          <div className="relative w-full h-full flex items-center justify-center overflow-hidden">
            <div className="absolute top-0 left-0 right-0 z-50 flex items-center justify-between p-4 bg-gradient-to-b from-black/80 via-black/40 to-transparent">
              <DialogClose asChild>
                <Button 
                  variant="ghost" 
                  size="sm" 
                  onClick={() => setIsOpen(false)} 
                  className="text-white hover:bg-white/20 h-10 w-10 p-0"
                  aria-label="Close viewer"
                >
                  <X className="h-5 w-5" />
                </Button>
              </DialogClose>

              <div className="flex items-center gap-3 bg-black/50 rounded-full px-4 py-2 backdrop-blur-sm">
                <Info className="h-4 w-4 text-white/80" />
                <div className="flex items-center gap-4 text-white/90 text-sm">
                  <span className="font-medium">{realFileName || 'Loading...'}</span>
                  <span>{Math.round(zoom * 100)}%</span>
                  {rotation > 0 && <span>{rotation}°</span>}
                </div>
              </div>

              <div className="flex gap-2">
                <Button
                  variant="secondary"
                  size="sm"
                  onClick={zoomOut}
                  disabled={zoom <= 0.25}
                  className="bg-white/10 hover:bg-white/20 text-white border-white/20 h-10 w-10 p-0"
                  aria-label="Zoom out"
                >
                  <ZoomOut className="h-4 w-4" />
                </Button>
                <Button
                  variant="secondary"
                  size="sm"
                  onClick={zoomIn}
                  disabled={zoom >= 5}
                  className="bg-white/10 hover:bg-white/20 text-white border-white/20 h-10 w-10 p-0"
                  aria-label="Zoom in"
                >
                  <ZoomIn className="h-4 w-4" />
                </Button>
                <Button
                  variant="secondary"
                  size="sm"
                  onClick={rotate}
                  className="bg-white/10 hover:bg-white/20 text-white border-white/20 h-10 w-10 p-0"
                  aria-label="Rotate"
                >
                  <RotateCw className="h-4 w-4" />
                </Button>
                <Button
                  variant="secondary"
                  size="sm"
                  onClick={handleDownload}
                  className="bg-white/10 hover:bg-white/20 text-white border-white/20 h-10 w-10 p-0"
                  aria-label="Download"
                >
                  <Download className="h-4 w-4" />
                </Button>
              </div>
            </div>

            <div
              className="w-full h-full flex items-center justify-center cursor-move select-none"
              style={{
                transform: `scale(${zoom}) rotate(${rotation}deg)`,
                transition: 'transform 0.2s ease-out',
              }}
              onClick={(e) => {
                if (e.target === e.currentTarget) {
                  setIsOpen(false);
                }
              }}
            >
              <img 
                src={src} 
                alt={alt || "Full size image"} 
                className="max-w-full max-h-full object-contain select-none pointer-events-none" 
                draggable={false}
                onError={(e) => {
                  console.error('Failed to load image:', src);
                }}
              />
            </div>

            <div className="absolute bottom-4 left-1/2 transform -translate-x-1/2 z-50">
              <div className="bg-black/60 text-white/80 text-xs px-3 py-2 rounded-full backdrop-blur-sm">
                <div className="flex items-center gap-4">
                  <span>ESC Close</span>
                  <span>+/- Zoom</span>
                  <span>R Rotate</span>
                  <span>0 Reset</span>
                </div>
              </div>
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </>
  );
}