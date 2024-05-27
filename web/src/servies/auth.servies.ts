import { loginEndpoint, loginNotifyNextServer } from "@/constants/endpoints";
import ILoginResponse from "@/interfaces/auth/ILoginResponse";
import { axiosClient } from "@/lib/axios/axiosClient";
import axios from "axios";
import { access } from "fs";

export const loginServices = async (email: string, password: string) => {
  try {
    const response = await axiosClient.post<ILoginResponse>(loginEndpoint, {
      email,
      password,
    });
    if (response.status == 200) {
      await axios.post(
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
  } catch (err) {}
};
