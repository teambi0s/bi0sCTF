import { Progress } from "@/components/ui/progress";

export default function ProgressIndicator({ isUploading, isSending, uploadProgress }) {
  if (!isUploading && !isSending) return null;

  return (
    <div className="mb-2 px-3">
      <Progress 
        value={isUploading ? uploadProgress : isSending ? 50 : 0} 
        className="h-1" 
      />
      <p className="text-xs text-muted-foreground text-right mt-1">
        {isUploading ? `Uploading: ${uploadProgress}%` : 'Sending...'}
      </p>
    </div>
  );
}