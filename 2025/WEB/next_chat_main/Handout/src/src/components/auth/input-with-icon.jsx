"use client";

import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

export default function InputWithIcon({
  id,
  name,
  label,
  type = "text",
  placeholder,
  icon: Icon,
  value,
  onChange,
  disabled = false,
  error = null,
  className = "",
  pattern = null,
  minLength = null,
  maxLength = null,
  autoComplete = null,
}) {
  return (
    <div className="space-y-2">
      {label && <Label htmlFor={id}>{label}</Label>}
      <div className="relative">
        {Icon && <Icon className="absolute left-3 top-2.5 h-4 w-4 text-muted-foreground" />}
        <Input
          id={id}
          name={name || id}
          type={type}
          placeholder={placeholder}
          className={`${Icon ? "pl-10" : ""} ${error ? "border-red-300" : ""} ${className}`}
          value={value}
          onChange={onChange}
          disabled={disabled}
          pattern={pattern}
          minLength={minLength}
          maxLength={maxLength}
          autoComplete={autoComplete}
        />
      </div>
    </div>
  );
}