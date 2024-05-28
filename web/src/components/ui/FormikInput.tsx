"use client";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useField } from "formik";
import { cn } from "@/lib/utils";
import { HTMLProps } from "react";
interface Props extends HTMLProps<HTMLInputElement> {
  name: string;
  className?: string;
}
const FormikInput = ({ name, className, label, ...rest }: Props) => {
  const [field, values, actions] = useField({ name });
  const isError = values.touched && values.error;
  return (
    <div className="flex flex-col space-y-2">
      <Label className={cn(`${isError && " text-red-400 "} capitalize`)}>
        {label}
      </Label>
      <Input
        {...rest}
        {...field}
        className={cn(`${isError && " ring-2 ring-red-300"}  `, className)}
      />
      {isError && (
        <span className="text-red-400 font-medium text-xs">{values.error}</span>
      )}
    </div>
  );
};

export default FormikInput;
