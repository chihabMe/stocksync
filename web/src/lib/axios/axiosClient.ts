"use client";
import axios from "axios";
import { env } from "../../../env";

export const axiosClient = axios.create({
  baseURL: env.NEXT_PUBLIC_API,

  withCredentials: true,
});
