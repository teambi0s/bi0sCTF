"use client";

import { useState, useEffect } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { signIn } from "next-auth/react";
import { Mail } from "lucide-react";
import { Button } from "@/components/ui/button";
import { toast } from "sonner";

import AuthLayout from "@/components/auth/auth-layout";
import AuthFormLayout from "@/components/auth/auth-form-layout";
import InputWithIcon from "@/components/auth/input-with-icon";
import PasswordInput from "@/components/auth/password-input";

export default function LoginLayout() {
  const router = useRouter();
  const searchParams = useSearchParams();
  
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [errors, setErrors] = useState({});

  useEffect(() => {
    if (searchParams.get("registered") === "true") {
      toast.success("Registration successful! Please log in.");
    }
    
    if (searchParams.get("error") === "Unauthorized") {
      toast.error("Please log in to continue");
    }
    
    const emailParam = searchParams.get("email");
    if (emailParam) {
      setEmail(emailParam);
    }
  }, [searchParams]);

  const validateForm = () => {
    const newErrors = {};
    
    if (!email.trim()) {
      toast.error("Email is required");
      newErrors.email = true;
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      toast.error("Please enter a valid email");
      newErrors.email = true;
    }
    
    if (!password) {
      toast.error("Password is required");
      newErrors.password = true;
    }
    
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!validateForm()) {
      return;
    }

    try {
      setIsLoading(true);

      const result = await signIn("credentials", {
        email,
        password,
        redirect: false,
      });

      if (result?.error) {
        toast.error("Invalid email or password");
      } else {
        toast.success("Successfully logged in!");
        router.push("/");
        router.refresh();
      }
    } catch (error) {
      console.error("Login error:", error);
      toast.error("An error occurred. Please try again.");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <AuthLayout 
      title="Welcome Back" 
      description="Sign in to your account to continue"
    >
      <AuthFormLayout
        footerText="Don't have an account?"
        footerLink="/auth/register"
        footerLinkText="Sign up"
        isLoading={isLoading}
      >
        <form onSubmit={handleSubmit} className="space-y-4">
          <InputWithIcon
            id="email"
            label="Email"
            type="email"
            placeholder="name@example.com"
            icon={Mail}
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            disabled={isLoading}
            error={errors.email}
            autoComplete="email"
          />

          <PasswordInput
            id="password"
            name="password"
            label="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            disabled={isLoading}
            error={errors.password}
            autoComplete="current-password"
          />

          <Button
            type="submit"
            className="w-full"
            disabled={isLoading}
          >
            {isLoading ? "Signing in..." : "Sign In"}
          </Button>
        </form>
      </AuthFormLayout>
    </AuthLayout>
  );
}