"use client";

import { useEffect, useRef, useState } from "react";
import { Button } from "@/components/ui/button";
import {
  Music,
  Play,
  Pause,
  Volume2,
  VolumeX,
  Download,
  Loader2,
} from "lucide-react";

export default function CustomAudioPlayer({ 
  src, 
  isCurrentUser, 
  timestamp, 
  senderName, 
  onDownload,
  realFileName 
}) {
  const audioRef = useRef(null);
  const [isPlaying, setIsPlaying] = useState(false);
  const [currentTime, setCurrentTime] = useState(0);
  const [duration, setDuration] = useState(0);
  const [isMuted, setIsMuted] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [downloadingAudio, setDownloadingAudio] = useState(false);

  useEffect(() => {
    const audio = audioRef.current;
    
    if (!audio) return;
    
    const handleLoadedMetadata = () => {
      setDuration(audio.duration);
      setIsLoading(false);
    };

    const handleTimeUpdate = () => {
      setCurrentTime(audio.currentTime);
    };

    const handleEnded = () => {
      setIsPlaying(false);
      setCurrentTime(0);
    };

    const handleLoadStart = () => {
      setIsLoading(true);
    };

    audio.addEventListener('loadedmetadata', handleLoadedMetadata);
    audio.addEventListener('timeupdate', handleTimeUpdate);
    audio.addEventListener('ended', handleEnded);
    audio.addEventListener('loadstart', handleLoadStart);

    return () => {
      audio.removeEventListener('loadedmetadata', handleLoadedMetadata);
      audio.removeEventListener('timeupdate', handleTimeUpdate);
      audio.removeEventListener('ended', handleEnded);
      audio.removeEventListener('loadstart', handleLoadStart);
    };
  }, [src]);

  const togglePlay = async () => {
    const audio = audioRef.current;
    if (!audio) return;

    try {
      if (isPlaying) {
        audio.pause();
        setIsPlaying(false);
      } else {
        await audio.play();
        setIsPlaying(true);
      }
    } catch (error) {
      console.error('Audio playback error:', error);
    }
  };

  const toggleMute = () => {
    const audio = audioRef.current;
    if (!audio) return;

    audio.muted = !audio.muted;
    setIsMuted(audio.muted);
  };

  const handleSeek = (e) => {
    const audio = audioRef.current;
    if (!audio) return;

    const rect = e.currentTarget.getBoundingClientRect();
    const percent = (e.clientX - rect.left) / rect.width;
    const newTime = percent * duration;
    audio.currentTime = newTime;
    setCurrentTime(newTime);
  };

  const handleDownload = async () => {
    if (onDownload) {
      setDownloadingAudio(true);
      try {
        await onDownload();
      } catch (error) {
        console.error('Download failed:', error);
      } finally {
        setDownloadingAudio(false);
      }
    }
  };

  const formatTime = (time) => {
    if (!isFinite(time)) return '0:00';
    const minutes = Math.floor(time / 60);
    const seconds = Math.floor(time % 60);
    return `${minutes}:${seconds.toString().padStart(2, '0')}`;
  };

  const progress = duration > 0 ? (currentTime / duration) * 100 : 0;

  return (
    <div className="w-full max-w-md">
      <div className="flex items-center gap-2 mb-2">
        {!isCurrentUser && senderName && <span className="text-sm font-medium text-foreground">{senderName}</span>}
        <span className="text-xs text-muted-foreground ml-auto">{timestamp}</span>
      </div>
      <div className="relative group">
        <div className="flex items-center gap-3 p-3 rounded-xl bg-muted/60 border border-muted-foreground/20">
          <audio ref={audioRef} src={src} preload="metadata" />
          <Button
            variant="ghost"
            size="sm"
            onClick={togglePlay}
            disabled={isLoading}
            className="h-10 w-10 rounded-full flex-shrink-0 bg-primary text-primary-foreground hover:bg-primary/90"
          >
            {isLoading ? (
              <div className="animate-spin rounded-full h-4 w-4 border-2 border-current border-t-transparent" />
            ) : isPlaying ? (
              <Pause className="h-4 w-4" />
            ) : (
              <Play className="h-4 w-4 ml-0.5" />
            )}
          </Button>
          <div className="flex-1 space-y-2">
            <div className="flex items-center gap-2">
              <Music className="h-3 w-3 text-muted-foreground" />
              <span className="text-xs text-muted-foreground">
                {realFileName ? realFileName : 'Audio file'}
              </span>
              <span className="text-xs text-muted-foreground ml-auto">
                {formatTime(currentTime)} / {formatTime(duration)}
              </span>
            </div>
            <div className="relative h-1.5 bg-muted-foreground/30 rounded-full cursor-pointer group" onClick={handleSeek}>
              <div className="absolute top-0 left-0 h-full bg-primary rounded-full transition-all" style={{ width: `${progress}%` }} />
              <div
                className="absolute top-1/2 w-3 h-3 bg-primary rounded-full -translate-y-1/2 transition-all opacity-0 group-hover:opacity-100 shadow-md"
                style={{ left: `calc(${progress}% - 6px)` }}
              />
            </div>
          </div>
          <Button
            variant="ghost"
            size="sm"
            onClick={toggleMute}
            className="h-8 w-8 flex-shrink-0 text-muted-foreground hover:text-foreground"
          >
            {isMuted ? <VolumeX className="h-4 w-4" /> : <Volume2 className="h-4 w-4" />}
          </Button>
          <Button
            variant="ghost"
            size="sm"
            onClick={handleDownload}
            disabled={downloadingAudio}
            className="h-8 w-8 flex-shrink-0 text-muted-foreground hover:text-foreground"
            title={`Download ${realFileName || 'audio file'}`}
          >
            {downloadingAudio ? (
              <Loader2 className="h-3 w-3 animate-spin" />
            ) : (
              <Download className="h-3 w-3" />
            )}
          </Button>
        </div>
      </div>
    </div>
  );
};