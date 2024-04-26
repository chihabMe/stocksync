export default interface IUser {
  id: string;
  username: string;
  email: string;
  is_active: boolean;
  user_type: "admin" | "seller" | "client";
  created_at: string;
  image?: string;
}
