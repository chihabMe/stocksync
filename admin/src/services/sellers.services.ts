import IUser from "@/interfaces/IUser";
import { axiosClient } from "@/lib/axios";
import { sellersActivationRequestEndpoint } from "@/utils/api_endpoints";

export const getSellersActivationRequest = async () => {
  const response = await axiosClient.get<IUser[]>(
    sellersActivationRequestEndpoint
  );
  return response.data;
};
