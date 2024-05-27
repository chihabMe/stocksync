import { meEndpoint } from "@/constants/endpoints";
import { axiosServer } from "@/lib/axios/axiosServer";
import { cookies } from "next/headers";

export const GET = async (request: Request) => {
  const access = cookies().get("access");
  const response = await axiosServer.get(meEndpoint, {
    headers: {
      Authorization: `Bearer ${access?.value}`,
    },
  });
  return Response.json(response.data);
};
