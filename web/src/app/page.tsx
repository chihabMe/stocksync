"use client";
import { meEndpoint } from "@/constants/endpoints";
import { axiosClient } from "@/lib/axios/axiosClient";
import { useEffect, useState } from "react";

export default function Home() {
  const [profile, setProfile] = useState<any>();
  useEffect(() => {
    async function getUser() {
      const response = await axiosClient.get(meEndpoint, {});
      setProfile(response.data);
    }
    getUser();
  }, [setProfile]);

  return <h1>{profile && JSON.stringify(profile)}</h1>;
}
