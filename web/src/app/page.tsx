"use client";
import { meEndpoint } from "@/constants/endpoints";
import { axiosClient } from "@/lib/axios/axiosClient";
import { useEffect } from "react";

export default function Home() {
  useEffect(() => {
    async function getUser() {
      const response = await axiosClient.get(meEndpoint, {
      });
      console.log(response);
    }
    getUser();
  }, []);

  return <h1>hello</h1>;
}
