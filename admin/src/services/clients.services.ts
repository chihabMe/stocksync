import IUser from "@/interfaces/IUser";
import { axiosClient } from "@/lib/axios";
import {
  clientManagerEndpoint,
  clientsListEndpoint,
} from "@/utils/api_endpoints";

export const getClient = async () => {
  return (await axiosClient.get<IUser[]>(clientsListEndpoint)).data;
};

export const deleteClient = async (id: string) => {
  return await axiosClient.delete(`${clientsListEndpoint}${id}/`);
};

export const toggleClientActivationState = async ({
  id,
  is_active,
}: {
  id: string;
  is_active: boolean;
}) => {
  return await axiosClient.put(`${clientManagerEndpoint}${id}/`, {
    is_active,
  });
};

export const deleteClientMutation = async (id: string) => {
  return await axiosClient.delete(`${clientManagerEndpoint}${id}/`);
};
