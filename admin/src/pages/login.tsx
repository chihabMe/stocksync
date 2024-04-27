import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { ChangeEvent, FormEvent, useState } from "react";
import axios from "axios";
import { obtainTokenEndpoint } from "@/utils/api_endpoints";
import { env } from "@/env";
import { cn } from "@/lib/utils";
import { Navigate, useNavigate } from "react-router-dom";
import useAuth from "@/hooks/useAuth";
import { LoadingSpinner } from "@/components/ui/loading-spinner";
const initialForm = {
  email: "",
  password: "",
};
export default function LoginPage() {
  const [form, setForm] = useState(initialForm);
  const [isLogin, setIsLogin] = useState(false);
  const [isError, setIsError] = useState(false);
  const { isLoading, user } = useAuth();

  const navigate = useNavigate();
  const handleFormSubmit = async (e: FormEvent) => {
    setIsLogin(true);
    e.preventDefault();
    const url = env.VITE_SERVER_HOST + obtainTokenEndpoint;

    try {
      const response = await axios.post(url, form);
      if (response.data) {
        localStorage.setItem("accessToken", response.data.access);
        localStorage.setItem("refreshToken", response.data.refresh);
        navigate("/admin");
      }
    } catch (err) {
      setIsError(true);
    }
    setIsLogin(false);
  };
  const handleInputChange = (e: ChangeEvent<HTMLInputElement>) => {
    if (isError) setIsError(false);
    setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }));
  };
  if (isLoading)
    return (
      <div className="w-full min-h-screen flex justify-center items-center">
        <LoadingSpinner className="text-primary w-12 h-12" />
      </div>
    );
  if (user) return <Navigate to="/admin" />;
  return (
    <main className="w-full min-h-screen flex justify-center items-center">
      <Card className="w-full max-w-md">
        <CardHeader>
          <CardTitle className="text-2xl">Signin</CardTitle>
          <CardDescription>
            {" "}
            to access the admin dashboard you have to provide a valid email and
            password
          </CardDescription>
        </CardHeader>
        <CardContent className="py-4">
          <form onSubmit={handleFormSubmit}>
            <div className="grid w-full items-center space-y-6">
              <div className="flex flex-col space-y-2">
                <Label className={cn(`${isError && " text-red-400 "}`)}>
                  Email
                </Label>
                <Input
                  onChange={handleInputChange}
                  name="email"
                  className={cn(
                    `${isError && "ring-red-300 text-red-300 ring-2"}`
                  )}
                />
              </div>
              <div className="flex flex-col space-y-2">
                <Label className={cn(`${isError && " text-red-400 "}`)}>
                  Password
                </Label>
                <Input
                  onChange={handleInputChange}
                  name="password"
                  type="password"
                  className={cn(
                    `${isError && "ring-red-300 text-red-300 ring-2"}`
                  )}
                />
              </div>
              <Button type="submit" className="flex justify-center relative ">
                {!isLogin && <span>login</span>}
                {isLogin && <LoadingSpinner className="w-4 h-4 " />}
              </Button>
            </div>
          </form>
        </CardContent>
      </Card>
    </main>
  );
}
