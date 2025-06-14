"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { useSession } from "next-auth/react";
import { Toaster } from "sonner";
import { Card, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { ImSpinner8 } from "react-icons/im";

export default function AuthLayout({
  children,
  title,
  description,
  cardClassName = "w-full max-w-md",
  redirectAuthenticated = true,
  loading = false,
}) {
  const router = useRouter();
  const { status } = useSession();

  useEffect(() => {
    if (redirectAuthenticated && status === "authenticated") {
      router.push("/");
    }
  }, [status, router, redirectAuthenticated]);

  if (status === "loading" || loading) {
    return (
      <div className="flex items-center justify-center min-h-screen bg-muted/30 p-4">
        <div className="flex flex-col items-center gap-4">
          <ImSpinner8 className="h-10 w-10 animate-spin text-primary" />
          <p className="text-muted-foreground">Loading...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="flex items-center justify-center min-h-screen bg-muted/30 p-4">
      <Toaster position="bottom-center" className="select-none" />
      <Card className={`shadow-md ${cardClassName}`}>
        {(title || description) && (
          <CardHeader className="space-y-1 text-center">
            {title && <CardTitle className="text-2xl font-bold">{title}</CardTitle>}
            {description && <CardDescription>{description}</CardDescription>}
          </CardHeader>
        )}
        {children}
      </Card>
    </div>
  );
}