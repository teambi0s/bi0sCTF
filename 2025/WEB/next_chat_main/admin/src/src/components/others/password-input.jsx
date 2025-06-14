"use client";

import { useState } from "react";
import { Eye, EyeOff, KeyRound } from "lucide-react";

export default function PasswordInput({ 
  name = "password", 
  placeholder = "Password", 
  value, 
  onChange, 
  required = true,
  showValidationHint = true,
  className = "",
  rightElement,
}) {
  const [showPassword, setShowPassword] = useState(false);
  
  const togglePasswordVisibility = () => {
    setShowPassword(!showPassword);
  };
  
  return (
    <div className={`mb-4 ${className}`}>
      <label className="input input-bordered w-full flex items-center gap-2 validator">
        <KeyRound className="h-[1em] opacity-50" />
        <input
          autoComplete="off"
          type={showPassword ? "text" : "password"}
          name={name}
          className="grow w-full"
          placeholder={placeholder}
          value={value}
          onChange={onChange}
          required={required}
          minLength="8"
          pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}"
          title="Must be more than 8 characters, including number, lowercase letter, uppercase letter"
        />
        {rightElement}
        <button 
          type="button" 
          className="password-toggle"
          onClick={togglePasswordVisibility}
        >
          {showPassword ? (
            <EyeOff className="h-5 w-5 cursor-pointer opacity-50" />
          ) : (
            <Eye className="h-5 w-5 cursor-pointer opacity-50" />
          )}
        </button>
      </label>
      {showValidationHint && (
        <p className="validator-hint hidden">
          Must be more than 8 characters, including
          <br />At least one number <br />At least one lowercase letter <br />At least one uppercase letter
        </p>
      )}
    </div>
  );
}