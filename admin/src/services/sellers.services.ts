import IListResponse from "@/interfaces/IListResponse";
import ISeller from "@/interfaces/ISeller";
import IUser from "@/interfaces/IUser";
import { axiosClient } from "@/lib/axios";
import {
  activateSellerEndpoint,
  sellersActivationRequestEndpoint,
  sellersListEndpoint,
} from "@/utils/api_endpoints";

export const getSellersActivationRequests = async ({
  page,
}: {
  page?: number;
} = {}) => {
  let pathWithQueries = sellersActivationRequestEndpoint;
  if (page) pathWithQueries += `?page=${page}`;

  const response = await axiosClient.get<IListResponse<IUser>>(pathWithQueries);
  return response.data;
};
export const approveSellerActivationRequest = async ({
  id,
  is_active,
}: {
  id: string;
  is_active: boolean;
}) => {
  const response = await axiosClient.put<ISeller>(
    `${activateSellerEndpoint}${id}/`,
    {
      is_active,
    }
  );
  return response.data;
};

export const getSellers = async () => {
  return (await axiosClient.get<IUser[]>(sellersListEndpoint)).data;
};
