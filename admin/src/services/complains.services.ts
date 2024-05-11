import IComplain from "@/interfaces/IComplain";
import IListResponse from "@/interfaces/IListResponse";
import { axiosClient } from "@/lib/axios";
import { complainManagerEndpoint } from "@/utils/api_endpoints";

export const getComplains = async ({ page }: { page: number }) => {
  let pathWithQueries = complainManagerEndpoint;
  if (page) pathWithQueries += `?page=${page}`;
  const response = await axiosClient.get<IListResponse<IComplain>>(
    pathWithQueries
  );
  return response.data;
};
