import IUser from "./IUser";

export default interface ISeller {
  is_active: boolean;
  user: IUser;
}
