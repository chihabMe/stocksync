export default interface IListResponse<T> {
  count: number;
  next: boolean;
  previous: boolean;
  results: T[];
}
