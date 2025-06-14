import { useState, useEffect } from "react";

export const useFilePermissions = (messages) => {
  const [filePermissions, setFilePermissions] = useState({});
  const [loadingFiles, setLoadingFiles] = useState({});

  useEffect(() => {
    const checkFilePermissions = async () => {
      const fileUrls = messages
        .filter(msg => msg.fileUrl)
        .map(msg => msg.fileUrl);

      const newFilesToCheck = fileUrls.filter(url => filePermissions[url] === undefined);

      if (newFilesToCheck.length === 0) return;

      const updatedPermissions = {};
      const updatedLoading = {};
      let hasUpdates = false;

      newFilesToCheck.forEach(url => {
        updatedLoading[url] = true;
      });
      setLoadingFiles(prev => ({ ...prev, ...updatedLoading }));

      for (const fileUrl of newFilesToCheck) {
        try {
          const response = await fetch(`/api/files/access?path=${encodeURIComponent(fileUrl)}`);
          const data = await response.json();
          updatedPermissions[fileUrl] = data.allowed;
          hasUpdates = true;
        } catch (error) {
          console.error("Error checking file permission:", error);
          updatedPermissions[fileUrl] = false;
          hasUpdates = true;
        } finally {
          updatedLoading[fileUrl] = false;
        }
      }

      if (hasUpdates) {
        setFilePermissions(prev => ({
          ...prev,
          ...updatedPermissions
        }));
        setLoadingFiles(prev => ({
          ...prev,
          ...updatedLoading
        }));
      }
    };

    checkFilePermissions();
  }, [messages, filePermissions]);

  return { filePermissions, loadingFiles };
};