import { axiosClient } from "@/lib/axios";
import { clientsListEndpoint } from "@/utils/api_endpoints";

export const getClient = async () => {
  return (await axiosClient.get(clientsListEndpoint)).data;
};
