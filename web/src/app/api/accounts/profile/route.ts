import { meEndpoint } from "@/constants/endpoints";
import { axiosServer } from "@/lib/axios/axiosServer";
import { cookies } from "next/headers";

export const GET = async (request: Request) => {
  const access = cookies().get("next_access");
  if (!access)
    return Response.json({ message: "Unauthorized" }, { status: 401 });
  try {
    const response = await axiosServer.get(meEndpoint, {
      headers: {
        Authorization: `Bearer ${access?.value}`,
      },
    });
    return Response.json(response.data);
  } catch (err) {
    console.error(err);
    return Response.json({ message: "Unauthorized" }, { status: 401 });
  }
};
