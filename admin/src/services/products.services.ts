import IListResponse from "@/interfaces/IListResponse";
import IProductCategory, {
  NewProductCategoryData,
} from "@/interfaces/IProductCategory";
import { axiosClient } from "@/lib/axios";
import { productsCategoriesManagerEndpoint } from "@/utils/api_endpoints";

export const getProductsCategories = async ({ page }: { page: number }) => {
  let pathWithQueries = productsCategoriesManagerEndpoint;
  if (page) pathWithQueries += `?page=${page}`;
  const response = await axiosClient.get<IListResponse<IProductCategory>>(
    pathWithQueries
  );
  return response.data;
};

export const deleteProductCategoryMutation = async (id: string) => {
  return await axiosClient.delete(`${productsCategoriesManagerEndpoint}${id}/`);
};

export const addCategoryMutationService = async (
  data: NewProductCategoryData
) => {
  return await axiosClient.post(`${productsCategoriesManagerEndpoint}`, data);
};
