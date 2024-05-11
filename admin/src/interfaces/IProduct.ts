import IProductCategory from "./IProductCategory";

export default interface IProduct {
  id: string;
  name: string;
  slug :string ;
  created_at: string;
  updated_at: string;
  description: string;
  price: number;
  stock: number;
  category: IProductCategory | null;
}
