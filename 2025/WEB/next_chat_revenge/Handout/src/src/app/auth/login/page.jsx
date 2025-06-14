"use client";

import LoginLayout from "@/components/layouts/login-layout";
import LoadingScreen from "@/components/others/loading-screen";
import { SessionProvider } from "next-auth/react";
import { Suspense } from "react";

export default function Login() {
  return (
    <SessionProvider>
      <Suspense fallback={<LoadingScreen />}>
        <LoginLayout />
      </Suspense>
    </SessionProvider>
  );
}