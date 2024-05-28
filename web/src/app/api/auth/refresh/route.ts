import { verifyTokenEndpoints } from "@/constants/endpoints";
import { axiosServer } from "@/lib/axios/axiosServer";
import { cookies } from "next/headers";

export const POST = async (request: Request) => {
  const data = await request.json();
  const access = data.access;
  if (!access) {
    return Response.json({ message: "invalid body" }, { status: 401 });
  }

  await axiosServer.post(verifyTokenEndpoints, {
    token: data.access,
  });
  const response = Response.json({ message: "success" });
  cookies().set("next_access", data.access, {
    maxAge: 60 * 30,
    httpOnly: true,
    path: "/",
    secure: process.env.NODE_ENV != "development",
  });

  return response;
};
