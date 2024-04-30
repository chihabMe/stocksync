import { Skeleton } from "@/components/ui/skeleton";
import { TableCell, TableRow } from "../ui/table";
const ListSkelton = () => {
  return (
    <>
      <ListSkeltonItem />
      <ListSkeltonItem />
      <ListSkeltonItem />
      <ListSkeltonItem />
    </>
  );
};
const ListSkeltonItem = () => {
  return (
    <TableRow>
      <TableCell className="hidden sm:table-cell">
        <Skeleton className="h-12 w-12 rounded-full" />
      </TableCell>
      <TableCell className="font-medium">
        <Skeleton className="h-4 w-[140px]" />
      </TableCell>

      <TableCell className="font-medium">
        <Skeleton className="h-4 w-[100px]" />
      </TableCell>
      <TableCell>
        <Skeleton className="h-4 w-[100px]" />
      </TableCell>
      <TableCell className="hidden md:table-cell">
        <Skeleton className="h-4 w-[100px]" />
      </TableCell>
      <TableCell className="hidden md:table-cell">
        <Skeleton className="h-4 w-[100px]" />
      </TableCell>
      <TableCell>
        <Skeleton className="h-4 w-[100px]" />
      </TableCell>
    </TableRow>
  );
};

export default ListSkelton;