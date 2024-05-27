"use server";
import axios from "axios";
import { env } from "../../../env";

export const axiosServer = axios.create({
  baseURL: env.API,
});
