import IClient from "./IClient";
import IProduct from "./IProduct";

export default interface IComplain {
    id:string;
  product: IProduct;
  client: IClient;
  description: string;
  created_at: string;
  updated_at: string;
  status:IComplainStatus ;
}

export type IComplainStatus = "pending" | "resolved" | "closed";