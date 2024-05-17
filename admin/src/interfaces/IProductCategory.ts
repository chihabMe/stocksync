export default interface IProductCategory {
  id: string;
  name: string;
  parent: IProductCategory | null;
  created_at: string;
}
export interface NewProductCategoryData {
  name: string;
}
