"use client";
import axios from "axios";
import { env } from "../../../env";
import {
  notifyRefreshNextServerEndpoint,
  refreshAuthCookieEndpoint,
} from "@/constants/endpoints";
import { access } from "fs";

export const axiosClient = axios.create({
  baseURL: env.NEXT_PUBLIC_API,
  withCredentials: true,
});

axiosClient.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;

    if (error.response.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true;

      try {
        const response = await axiosClient.post(refreshAuthCookieEndpoint);

        if (response.status === 200) {
          // Retry the original request with the new token
          await axios.post(notifyRefreshNextServerEndpoint, {
            access: response.data.access,
          });
          return axiosClient(originalRequest);
        }
      } catch (refreshError) {
        // Handle refresh token error (optional)
        return Promise.reject(refreshError);
      }
    }

    return Promise.reject(error);
  }
);
