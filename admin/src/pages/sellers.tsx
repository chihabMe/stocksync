import { getSellersActivationRequest } from "@/services/sellers.services";
import { useQuery } from "@tanstack/react-query";

import { MoreHorizontal } from "lucide-react";

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import IUser from "@/interfaces/IUser";
import { LoadingSpinner } from "@/components/ui/loading-spinner";

const SellersPage = () => {
  const { isLoading, isError, data } = useQuery({
    queryKey: ["sellersactivationrequest"],
    queryFn: getSellersActivationRequest,
  });
  console.log(isLoading);
  console.log(data);
  if (isLoading) return <LoadingSpinner />;
  if (!data) return <h1>error</h1>;

  return (
    <Card className="">
      <CardHeader>
        <CardTitle>Activation requests </CardTitle>
        <CardDescription>
          you can see all of the activation request and take actions on them
        </CardDescription>
      </CardHeader>
      <CardContent className="min-h-[65vh]">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead className="hidden w-[100px] sm:table-cell">
                <span className="sr-only">Image</span>
              </TableHead>
              <TableHead>name</TableHead>
              <TableHead>email</TableHead>
              <TableHead className="hidden md:table-cell">status</TableHead>
              <TableHead className="hidden md:table-cell">
                user type
              </TableHead>
              <TableHead className="hidden md:table-cell">registered at</TableHead>
              <TableHead>
                actions
              </TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {data.map((user) => (
              <ActivationRequestRowItem key={user.id} user={user} />
            ))}
          </TableBody>
        </Table>
      </CardContent>
      <CardFooter className="">
        <div className="text-xs text-muted-foreground">
          Showing <strong>1-10</strong> of <strong>32</strong> products
        </div>
      </CardFooter>
    </Card>
  );
};

const ActivationRequestRowItem = ({ user }: { user: IUser }) => {
  const created_at = new Date(user.created_at).toLocaleDateString("en-US", {day: "numeric", month: "short", year: "numeric",hour: "numeric", minute: "numeric"})
  return (
    <TableRow>
      <TableCell className="hidden sm:table-cell">
        <img
          alt="Product image"
          className="aspect-square rounded-md object-cover"
          height="64"
          src="/placeholder.svg"
          width="64"
        />
      </TableCell>
      <TableCell className="font-medium">{user.email}</TableCell>
      <TableCell className="hidden md:table-cell">
        {user.username ?? "None"}
      </TableCell>
      <TableCell>
        <Badge variant="destructive">inactive</Badge>
      </TableCell>
      <TableCell className="hidden md:table-cell">{user.user_type}</TableCell>
      <TableCell className="hidden md:table-cell">{created_at}</TableCell>
      <TableCell>
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button aria-haspopup="true" size="icon" variant="ghost">
              <MoreHorizontal className="h-4 w-4" />
              <span className="sr-only">Toggle menu</span>
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            <DropdownMenuLabel >Actions</DropdownMenuLabel>
            <DropdownMenuItem className="cursor-pointer">Active</DropdownMenuItem>
            <DropdownMenuItem className="text-destructive cursor-pointer hover:!text-white hover:!bg-destructive">
              Delete
              </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </TableCell>
    </TableRow>
  );
};

export default SellersPage;
