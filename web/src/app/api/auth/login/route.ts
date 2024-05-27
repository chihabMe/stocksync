import { verifyTokenEndpoints } from "@/constants/endpoints";
import { axiosServer } from "@/lib/axios/axiosServer";
import { AxiosError } from "axios";
import { cookies } from "next/headers";
interface RequestBody {
  access: string;
}
export const POST = async (request: Request) => {
  const data = await request.json();
  if (!data.access || !data.refresh) {
    return Response.json(
      { message: "invalid body" },
      {
        status: 401,
      }
    );
  }
  try {
    await axiosServer.post(verifyTokenEndpoints, {
      token: data.access,
    });

    await axiosServer.post(verifyTokenEndpoints, {
      token: data.refresh,
    });
    const response = Response.json({ message: "success" });
    cookies().set("access", data.access, {
      maxAge: 60 * 30,
      httpOnly: true,
      path: "/",
      secure: process.env.NODE_ENV != "development",
    });

    cookies().set("refresh", data.access, {
      maxAge: 60 * 60 * 24 * 20,
      httpOnly: true,
      path: "/",
      secure: process.env.NODE_ENV != "development",
    });
    return response;
  } catch (error) {
    if (error instanceof AxiosError) {
      console.error(error.cause);
      console.error(error.message);
      console.error(error.response?.data);
    } else {
      console.error(error);
    }
  }
  return Response.json({ message: "unable to login" }, { status: 401 });
};
