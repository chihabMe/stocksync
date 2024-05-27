import { loginEndpoint } from "@/constants/endpoints";
import ILoginResponse from "@/interfaces/auth/ILoginResponse";
import { axiosClient } from "@/lib/axios";

export const loginServices = async (email: string, password: string) => {
  return axiosClient.post<ILoginResponse>(loginEndpoint, {
    email,
    password,
  });
};
