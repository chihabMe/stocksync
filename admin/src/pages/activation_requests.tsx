import {
  approveSellerActivationRequest,
  getSellersActivationRequests,
} from "@/services/sellers.services";
import { useMutation, useQuery } from "@tanstack/react-query";

import { MoreHorizontal } from "lucide-react";

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
import { useSearchParams } from "react-router-dom";
import { useEffect, useState } from "react";
import Paginator from "@/components/layout/paginator";
import IListResponse from "@/interfaces/IListResponse";
import { toast } from "@/components/ui/use-toast";
import ListSkelton from "@/components/layout/list.skelton";

const sellersQueryKey = "sellers-activation-requests";
const ActivationRequestsPage = () => {
  const [searchParams, setSearchParams] = useSearchParams();
  const p = parseInt(searchParams.get("page") as unknown as string) || 1;
  const [page, setPage] = useState(p);
  const increasePage = () => setPage((prev) => prev + 1);
  const decreasePage = () => setPage((prev) => prev - 1);
  const goToPage = (page: number) => {
    if (page >= 1) {
      setPage(page);
    }
  };
  useEffect(() => {
    setSearchParams({ page: page.toString() });
  }, [page]);
  const { isLoading, isError, data } = useQuery({
    queryKey: [sellersQueryKey, page],
    queryFn: () => getSellersActivationRequests({ page }),
  });
  if (isError) return <h1>error</h1>;

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
            {isLoading && <ListSkelton />}
            {!isLoading &&
              data &&
              data.results.map((user) => (
                <ActivationRequestRowItem
                  key={user.id}
                  page={page}
                  user={user}
                />
              ))}
          </TableBody>
        </Table>
      </CardContent>
      {data && (
        <>
          <CardFooter className="">
            <Paginator
              page={page}
              increasePage={increasePage}
              decreasePage={decreasePage}
              goToPage={goToPage}
              hasNext={data.next != null}
              hasPrev={data.previous != null}
              totalPages={Math.floor(data.count / 5)}
            />
            <div className="text-xs text-muted-foreground">
              Showing <strong>5</strong> of <strong>{data.count}</strong>{" "}
              requests
            </div>
          </CardFooter>
        </>
      )}
    </Card>
  );
};

const ActivationRequestRowItem = ({
  user,
  page,
}: {
  user: IUser;
  page: number;
}) => {
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
            <UserActivationAction user={user} page={page} />
            <UserDeletionAction user={user} page={page} />
          </DropdownMenuContent>
        </DropdownMenu>
      </TableCell>
    </TableRow>
  );
};

export default ActivationRequestsPage;

const UserDeletionAction = ({ user, page }: { user: IUser; page: number }) => {
  const deleteUserMutation = useMutation({
    mutationFn: deleteClientMutation,
    onMutate: async (id) => {
      await queryClient.cancelQueries({
        queryKey: [sellersQueryKey, page],
      });
      const previousRequests = queryClient.getQueryData<IUser[]>([
        sellersQueryKey,
      ]);
      queryClient.setQueryData([sellersQueryKey, page], (old: IUser[]) => {
        return old.filter((item) => item.id !== id);
      });
      return { previousRequests };
    },
    onError: (err, data, context) => {
      console.log(data)
      console.error(err)
      toast({ title: "unable to delete the user" });
      queryClient.setQueryData(
        [sellersQueryKey, page],
        context?.previousRequests
      );
    },
  });

  const handleUserDeletion = () => {
    deleteUserMutation.mutate(user.id, {
      onSuccess: () => {
        toast({
          variant: "success",
          title: `User deleted successfully`,
        });
      },
    });
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

const UserActivationAction = ({
  user,
  page,
}: {
  user: IUser;
  page: number;
}) => {
  const activeUserMutton = useMutation({
    mutationFn: approveSellerActivationRequest,
    onMutate: async ({ id }) => {
      await queryClient.cancelQueries({
        queryKey: [sellersQueryKey, page],
      });
      console.log("hello world");
      const previousActivationRequests = queryClient.getQueryData<IUser[]>([
        sellersQueryKey,
        page,
      ]);
      queryClient.setQueryData(
        [sellersQueryKey, page],
        (old: IListResponse<IUser>) => {
          return {
            ...old,
            results: old.results.map((item) => {
              if (item.id == id) return { ...item, is_active: !item.is_active };
              return item;
            }),
          };
        }
      );
      return { previousActivationRequests };
    },
    onError: (err, data, context) => {
      console.log(err, data);
      toast({ variant: "destructive", title: "unable to activate the user" });
      queryClient.setQueryData(
        [sellersQueryKey, page],
        context?.previousActivationRequests
      );
    },
  });

  const handleUserActivation = () => {
    activeUserMutton.mutate(
      {
        id: user.id,
        is_active: !user.is_active,
      },
      {
        onSuccess: (data) => {
          toast({
            variant: "success",
            title: `User ${data.is_active ? "activated" : "deactivated"}`,
          });
        },
      }
    );
  };
  return (
    <DropdownMenuItem onClick={handleUserActivation} className="cursor-pointer">
      {user.is_active ? <span>Inactive</span> : <span>Active</span>}
      {activeUserMutton.isPending && <LoadingSpinner />}
    </DropdownMenuItem>
  );
};
