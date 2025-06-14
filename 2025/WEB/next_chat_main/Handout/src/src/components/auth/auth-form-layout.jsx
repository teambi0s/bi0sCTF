"use client";

import Link from "next/link";
import { CardContent, CardFooter } from "@/components/ui/card";

export default function AuthFormLayout({
  children,
  footerText,
  footerLink,
  footerLinkText,
  additionalFooter,
  isLoading,
}) {
  return (
    <>
      <CardContent>
        <div className="grid gap-4">
          {children}
        </div>
      </CardContent>

      <CardFooter className="flex flex-col space-y-3">
        {footerText && (
          <div className="text-sm text-center text-muted-foreground">
            {footerText}{" "}
            <Link href={footerLink} className="text-primary hover:underline">
              {footerLinkText}
            </Link>
          </div>
        )}
        {additionalFooter && <div className="text-sm text-center text-muted-foreground">{additionalFooter}</div>}
      </CardFooter>
    </>
  );
}