"use client";

import { useState } from "react";
import { Eye, EyeOff } from "lucide-react";

export default function FormInput({ 
  icon, 
  type = "text", 
  name, 
  placeholder, 
  value, 
  onChange, 
  required = false,
  pattern,
  minLength,
  maxLength,
  title,
  className = "",
  validationHint,
  rightElement,
}) {
  const [showPassword, setShowPassword] = useState(false);
  
  const togglePasswordVisibility = () => {
    setShowPassword(!showPassword);
  };
  
  const isPassword = type === "password";
  const inputType = isPassword ? (showPassword ? "text" : "password") : type;
  
  return (
    <div className={`mb-4 ${className}`}>
      <label className="input input-bordered w-full flex items-center gap-2 validator">
        {icon}
        <input 
          autoComplete="off"
          type={inputType}
          name={name}
          placeholder={placeholder}
          className="grow w-full"
          value={value}
          onChange={onChange}
          required={required}
          pattern={pattern}
          minLength={minLength}
          maxLength={maxLength}
          title={title}
        />
        {rightElement}
        {isPassword && (
          <button 
            type="button" 
            className="password-toggle"
            onClick={togglePasswordVisibility}
          >
            {showPassword ? (
              <EyeOff className="h-5 w-5 cursor-pointer" />
            ) : (
              <Eye className="h-5 w-5 cursor-pointer" />
            )}
          </button>
        )}
      </label>
      {validationHint && (
        <p className="validator-hint hidden">{validationHint}</p>
      )}
    </div>
  );
}