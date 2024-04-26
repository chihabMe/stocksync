import ISeller from "@/interfaces/ISeller";
import IUser from "@/interfaces/IUser";
import { axiosClient } from "@/lib/axios";
import {
  activateSellerEndpoint,
  sellersActivationRequestEndpoint,
  sellersListEndpoint,
} from "@/utils/api_endpoints";

export const getSellersActivationRequest = async () => {
  const response = await axiosClient.get<IUser[]>(
    sellersActivationRequestEndpoint
  );
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
