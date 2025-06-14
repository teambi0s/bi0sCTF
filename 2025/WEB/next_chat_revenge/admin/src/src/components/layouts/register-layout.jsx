"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { Mail, UserRound } from "lucide-react";
import { Button } from "@/components/ui/button";
import { toast } from "sonner";

import AuthLayout from "@/components/auth/auth-layout";
import AuthFormLayout from "@/components/auth/auth-form-layout";
import InputWithIcon from "@/components/auth/input-with-icon";
import PasswordInput from "@/components/auth/password-input";

export default function RegisterLayout() {
  const [formData, setFormData] = useState({
    email: "",
    username: "",
    password: "",
    confirmPassword: "",
  });
  const [isLoading, setIsLoading] = useState(false);
  const [errors, setErrors] = useState({});
  const router = useRouter();

  useEffect(() => {
    if (formData.confirmPassword) {
      if (formData.password !== formData.confirmPassword) {
        setErrors(prev => ({ ...prev, confirmPassword: true }));
      } else {
        setErrors(prev => {
          const newErrors = { ...prev };
          delete newErrors.confirmPassword;
          return newErrors;
        });
      }
    }
  }, [formData.password, formData.confirmPassword]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));
    
    if (errors[name]) {
      setErrors(prev => {
        const newErrors = { ...prev };
        delete newErrors[name];
        return newErrors;
      });
    }
  };

  const validateForm = () => {
    const newErrors = {};
    
    if (!formData.username.trim()) {
      toast.error("Username is required");
      newErrors.username = true;
    } else if (formData.username.length < 3) {
      toast.error("Username must be at least 3 characters");
      newErrors.username = true;
    } else if (!/^[A-Za-z][A-Za-z0-9\-_]*$/.test(formData.username)) {
      toast.error("Username must start with a letter and contain only letters, numbers, hyphens, or underscores");
      newErrors.username = true;
    }
    
    if (!formData.email.trim()) {
      toast.error("Email is required");
      newErrors.email = true;
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) {
      toast.error("Please enter a valid email");
      newErrors.email = true;
    }
    
    if (!formData.password) {
      toast.error("Password is required");
      newErrors.password = true;
    } else if (formData.password.length < 8) {
      toast.error("Password must be at least 8 characters");
      newErrors.password = true;
    } else if (!/(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/.test(formData.password)) {
      toast.error("Password must contain at least one uppercase letter, one lowercase letter, and one number");
      newErrors.password = true;
    }
    
    if (!formData.confirmPassword) {
      toast.error("Please confirm your password");
      newErrors.confirmPassword = true;
    } else if (formData.password !== formData.confirmPassword) {
      toast.error("Passwords do not match");
      newErrors.confirmPassword = true;
    }
    
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (!validateForm()) {
      toast.error("Please correct the errors in the form");
      return;
    }

    setIsLoading(true);

    try {
      const response = await fetch("/api/auth/register", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          email: formData.email,
          name: formData.username,
          password: formData.password,
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || "Registration failed");
      }

      toast.success("Registration successful!");

      setTimeout(() => {
        router.push(`/auth/login?registered=true&email=${encodeURIComponent(formData.email)}`);
      }, 1500);
    } catch (error) {
      if (error.message.includes("already exists")) {
        toast.error("Email already registered. Please login instead.");
      } else {
        toast.error(error.message || "Something went wrong. Please try again.");
      }
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <AuthLayout 
      title="Create an Account" 
      description="Sign up to get started"
    >
      <AuthFormLayout
        footerText="Already have an account?"
        footerLink="/auth/login"
        footerLinkText="Log In"
        additionalFooter={
          <p className="mt-2">
            By registering, you agree to our{" "}
            <a href="/terms" className="text-primary hover:underline">Terms of Service</a> and{" "}
            <a href="/privacy" className="text-primary hover:underline">Privacy Policy</a>
          </p>
        }
        isLoading={isLoading}
      >
        <form onSubmit={handleSubmit} className="space-y-4">
          <InputWithIcon
            id="username"
            name="username"
            label="Username"
            placeholder="johndoe"
            icon={UserRound}
            value={formData.username}
            onChange={handleChange}
            disabled={isLoading}
            error={errors.username}
            autoComplete="username"
          />

          <InputWithIcon
            id="email"
            name="email"
            label="Email"
            type="email"
            placeholder="name@example.com"
            icon={Mail}
            value={formData.email}
            onChange={handleChange}
            disabled={isLoading}
            error={errors.email}
            autoComplete="email"
          />

          <PasswordInput
            id="password"
            name="password"
            label="Password"
            value={formData.password}
            onChange={handleChange}
            disabled={isLoading}
            error={errors.password}
            autoComplete="new-password"
          />

          <PasswordInput
            id="confirmPassword"
            name="confirmPassword"
            label="Confirm Password"
            value={formData.confirmPassword}
            onChange={handleChange}
            disabled={isLoading}
            error={errors.confirmPassword}
            autoComplete="new-password"
          />

          <Button type="submit" className="w-full" disabled={isLoading}>
            {isLoading ? "Creating Account..." : "Register"}
          </Button>
        </form>
      </AuthFormLayout>
    </AuthLayout>
  );
}