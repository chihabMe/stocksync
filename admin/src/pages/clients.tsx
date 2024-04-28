import { useMutation, useQuery } from "@tanstack/react-query";

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
import { queryClient } from "@/main";
import {
  deleteClientMutation,
  getClients,
  toggleClientActivationState,
} from "@/services/clients.services";
import { toast } from "@/components/ui/use-toast";
import { useEffect, useState } from "react";
import { useSearchParams } from "react-router-dom";
import IListResponse from "@/interfaces/IListResponse";
import Paginator from "@/components/layout/paginator";

const ClientsPage = () => {
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

  const { isLoading, data } = useQuery({
    queryKey: ["clients", page],
    queryFn: () => getClients({ page }),
  });
  if (isLoading) return <LoadingSpinner />;
  if (!data) return <h1>error</h1>;

  return (
    <Card className="">
      <CardHeader>
        <CardTitle>Clients</CardTitle>
        <CardDescription>list of all active clients</CardDescription>
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
            {data.results.map((user) => (
              <ActivationRequestRowItem key={user.id} page={page} user={user} />
            ))}
          </TableBody>
        </Table>
      </CardContent>
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
          Showing <strong>1-10</strong> of <strong>32</strong> products
        </div>
      </CardFooter>
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
          alt="client image"
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
            <ClientActivationAction user={user} page={page} />
            <ClientDeletionAction user={user} page={page} />
          </DropdownMenuContent>
        </DropdownMenu>
      </TableCell>
    </TableRow>
  );
};

const ClientDeletionAction = ({
  user,
  page,
}: {
  user: IUser;
  page: number;
}) => {
  const deleteUserMutation = useMutation({
    mutationFn: deleteClientMutation,
    onMutate: async (id) => {
      await queryClient.cancelQueries({
        queryKey: ["clients", page],
      });
      const previousRequests = queryClient.getQueryData<IListResponse<IUser>>([
        "clients",
        page,
      ]);
      queryClient.setQueryData(
        ["clients", page],
        (old: IListResponse<IUser>) => {
          return {
            ...old,
            results: old.results.filter((item) => item.id !== id),
          };
        }
      );
      return { previousRequests };
    },
    onError: (err, data, context) => {
      toast({ variant: "destructive", title: "unable to delete the user" });
      queryClient.setQueryData(["clients", page], context?.previousRequests);
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
const ClientActivationAction = ({
  user,
  page,
}: {
  user: IUser;
  page: number;
}) => {
  const activeUserMutton = useMutation({
    mutationFn: toggleClientActivationState,
    onSuccess: (data) => {
      toast({
        variant: "success",
        title: `User ${data.data.user.is_active ? "activated" : "deactivated"}`,
      });
    },
    onMutate: async ({ id }) => {
      await queryClient.cancelQueries({
        queryKey: ["clients", page],
      });
      const previousActivationRequests = queryClient.getQueryData<IUser[]>([
        "clients",
        page,
      ]);
      queryClient.setQueryData(
        ["clients", page],
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
      queryClient.setQueryData(
        ["clients", page],
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

export default ClientsPage;
