"use client";

import RegisterLayout from "@/components/layouts/register-layout";
import LoadingScreen from "@/components/others/loading-screen";
import { SessionProvider } from "next-auth/react";
import { Suspense } from "react";

export default function Register() {
  return (
    <SessionProvider>
      <Suspense fallback={<LoadingScreen />}>
        <RegisterLayout />
      </Suspense>
    </SessionProvider>
  );
}