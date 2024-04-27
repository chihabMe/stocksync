import {
  approveSellerActivationRequest,
  getSellersActivationRequest,
} from "@/services/sellers.services";
import { useMutation, useQuery } from "@tanstack/react-query";

import { MoreHorizontal, User } from "lucide-react";

import { Badge } from "@/components/ui/badge";
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
import { queryClient } from "@/main";
import { Button } from "@/components/ui/button";
import { deleteClientMutation } from "@/services/clients.services";
import {
  Pagination,
  PaginationContent,
  PaginationEllipsis,
  PaginationItem,
  PaginationLink,
  PaginationNext,
  PaginationPrevious,
} from "@/components/ui/pagination";

const ActivationRequestsPage = () => {
  const { isLoading, data } = useQuery({
    queryKey: ["sellers-activation-requests"],
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
              <TableHead className="">image</TableHead>
              <TableHead>email</TableHead>
              <TableHead>name</TableHead>
              <TableHead className="hidden md:table-cell">status</TableHead>
              <TableHead className="hidden md:table-cell">user type</TableHead>
              <TableHead className="hidden md:table-cell">
                registered at
              </TableHead>
              <TableHead>actions</TableHead>
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

        <Pagination>
          <PaginationContent>
            <PaginationItem>
              <PaginationPrevious className="hover:bg-primary hover:text-white" href="#"  />
            </PaginationItem>
            <PaginationItem>
              <PaginationLink href="#">1</PaginationLink>
            </PaginationItem>

            <PaginationItem>
              <PaginationLink href="#">2</PaginationLink>
            </PaginationItem>

            <PaginationItem>
              <PaginationLink href="#">3</PaginationLink>
            </PaginationItem>



            {/* <PaginationItem>
              <PaginationEllipsis />
            </PaginationItem> */}
            <PaginationItem className="">
              <PaginationNext href="#" className="hover:bg-primary hover:text-white" />
            </PaginationItem>
          </PaginationContent>
        </Pagination>
      </CardFooter>
    </Card>
  );
};

const ActivationRequestRowItem = ({ user }: { user: IUser }) => {
  const created_at = new Date(user.created_at).toLocaleDateString("en-US", {
    day: "numeric",
    month: "short",
    year: "numeric",
    hour: "numeric",
    minute: "numeric",
  });
  return (
    <TableRow>
      <TableCell className="hidden sm:table-cell">
        <img
          alt="seller image"
          className="aspect-square rounded-md object-cover"
          height="64"
          src={user?.image}
          width="64"
        />
      </TableCell>
      <TableCell className="font-medium">{user.email}</TableCell>
      <TableCell className="hidden md:table-cell">
        {user.username ?? "None"}
      </TableCell>
      <TableCell>
        {user.is_active ? (
          <Badge variant="success" className="w-[80px] flex justify-center">
            active
          </Badge>
        ) : (
          <Badge variant="destructive" className="w-[80px] flex justify-center">
            inactive
          </Badge>
        )}
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
            <DropdownMenuLabel>Actions</DropdownMenuLabel>
            <UserActivationAction user={user} />
            <UserDeletionAction user={user} />
          </DropdownMenuContent>
        </DropdownMenu>
      </TableCell>
    </TableRow>
  );
};

export default ActivationRequestsPage;

const UserDeletionAction = ({ user }: { user: IUser }) => {
  const deleteUserMutation = useMutation({
    mutationFn: deleteClientMutation,
    onMutate: async (id) => {
      console.log("mutate");
      console.log(id);
      await queryClient.cancelQueries({
        queryKey: ["sellers-activation-requests"],
      });
      const previousRequests = queryClient.getQueryData<IUser[]>([
        "sellers-activation-requests",
      ]);
      queryClient.setQueryData(
        ["sellers-activation-requests"],
        (old: IUser[]) => {
          console.log(old);
          return old.filter((item) => item.id !== id);
        }
      );
      return { previousRequests };
    },
    onError: (err, data, context) => {
      console.log(err, data);
      queryClient.setQueryData(
        ["sellers-activation-requests"],
        context?.previousRequests
      );
    },
  });

  const handleUserDeletion = () => {
    deleteUserMutation.mutate(user.id);
  };

  return (
    <DropdownMenuItem
      onClick={handleUserDeletion}
      className="text-destructive cursor-pointer hover:!text-white hover:!bg-destructive"
    >
      Delete
    </DropdownMenuItem>
  );
};

const UserActivationAction = ({ user }: { user: IUser }) => {
  const activeUserMutton = useMutation({
    mutationFn: approveSellerActivationRequest,
    onMutate: async ({ id }) => {
      await queryClient.cancelQueries({
        queryKey: ["sellers-activation-requests"],
      });
      const previousActivationRequests = queryClient.getQueryData<IUser[]>([
        "sellers-activation-requests",
      ]);
      queryClient.setQueryData(
        ["sellers-activation-requests"],
        (old: IUser[]) => {
          return old.map((item) => {
            if (item.id == id) return { ...item, is_active: !item.is_active };
            return item;
          });
        }
      );
      return { previousActivationRequests };
    },
    onError: (err, data, context) => {
      console.log(err, data);
      queryClient.setQueryData(
        ["sellers-activation-requests"],
        context?.previousActivationRequests
      );
    },
  });

  const handleUserActivation = () => {
    activeUserMutton.mutate({
      id: user.id,
      is_active: !user.is_active,
    });
  };
  return (
    <DropdownMenuItem onClick={handleUserActivation} className="cursor-pointer">
      {user.is_active ? <span>Inactive</span> : <span>Active</span>}
      {activeUserMutton.isPending && <LoadingSpinner />}
    </DropdownMenuItem>
  );
};
