import {
  loginEndpoint,
  loginNotifyNextServer,
  signupEndpoint,
} from "@/constants/endpoints";
import ILoginResponse from "@/interfaces/auth/ILoginResponse";
import { axiosClient } from "@/lib/axios/axiosClient";
import axios from "axios";

export const loginServices = async (email: string, password: string) => {
  let response = await axiosClient.post<ILoginResponse>(loginEndpoint, {
    email,
    password,
  });
  if (response.status == 200) {
    response = await axios.post(
      loginNotifyNextServer,
      {
        access: response.data.access,
        refresh: response.data.refresh,
      },
      {
        withCredentials: true,
      }
    );
  }
  return response;
};

export const signupServices = async (data: {
  email: string;
  password: string;
  password2: string;
  username: string;
}) => {
  return axiosClient.post(signupEndpoint, { ...data, user_type: "client" });
};
