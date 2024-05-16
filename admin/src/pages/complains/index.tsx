import { useMutation, useQuery } from "@tanstack/react-query";

import { MoreHorizontal } from "lucide-react";

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
import { queryClient } from "@/main";
import { toast } from "@/components/ui/use-toast";
import { useEffect, useState } from "react";
import { useSearchParams } from "react-router-dom";
import IListResponse from "@/interfaces/IListResponse";
import Paginator from "@/components/layout/paginator";
import ListSkelton from "@/components/layout/list.skelton";
import IComplain from "@/interfaces/IComplain";
import {
  deleteComplainMutation,
  getComplains,
} from "@/services/complains.services";
import { ComplainModal } from "./components/ComplainModal";
import { Badge } from "@/components/ui/badge";

const queryKey = "complains";
const ComplainsPage = () => {
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
    queryKey: [queryKey, page],
    queryFn: () => getComplains({ page }),
  });
  if (!isLoading && !data) return <h1>error</h1>;

  return (
    <Card className="">
      <CardHeader>
        <CardTitle>Complains</CardTitle>
        <CardDescription>list of all complains</CardDescription>
      </CardHeader>
      <CardContent className="min-h-[65vh]">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>client</TableHead>
              <TableHead>product name</TableHead>
              <TableHead className="hidden md:table-cell">status</TableHead>
              <TableHead className="hidden md:table-cell">created at</TableHead>
              <TableHead>actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {isLoading && <ListSkelton />}
            {!isLoading &&
              data &&
              data.results.map((complain) => (
                <ComplainsRow
                  key={complain.id}
                  page={page}
                  complain={complain}
                />
              ))}
          </TableBody>
        </Table>
      </CardContent>
      <CardFooter className="">
        {!isLoading && data && (
          <>
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
              Showing <strong>1-10</strong> of <strong>32</strong> complains
            </div>
          </>
        )}
      </CardFooter>
    </Card>
  );
};

const ComplainsRow = ({
  complain,
  page,
}: {
  complain: IComplain;
  page: number;
}) => {
  const created_at = new Date(complain.created_at).toLocaleDateString("en-US", {
    day: "numeric",
    month: "short",
    year: "numeric",
    hour: "numeric",
    minute: "numeric",
  });
  const [open, setOpen] = useState(false);
  const openModal = () => setOpen(true);
  return (
    <TableRow onClick={openModal} className="cursor-pointer">
      <ComplainModal
        page={page}
        setOpen={setOpen}
        open={open}
        complain={complain}
      />
      <TableCell className="font-medium">
        {complain.client.user.username}
      </TableCell>
      <TableCell className="hidden md:table-cell">
        {complain.product.name ?? "None"}
      </TableCell>
      <TableCell className="hidden md:table-cell">
        <Badge variant={complain.status == "closed" ? "success" : "default"}>
          {complain.status}
        </Badge>
      </TableCell>
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
            <ComplainDeletionAction complain={complain} page={page} />
          </DropdownMenuContent>
        </DropdownMenu>
      </TableCell>
    </TableRow>
  );
};

const ComplainDeletionAction = ({
  complain,
  page,
}: {
  complain: IComplain;
  page: number;
}) => {
  const deleteUserMutation = useMutation({
    mutationFn: deleteComplainMutation,
    onMutate: async (id) => {
      await queryClient.cancelQueries({
        queryKey: [queryKey, page],
      });
      const previousRequests = queryClient.getQueryData<
        IListResponse<IComplain>
      >([queryKey, page]);
      queryClient.setQueryData(
        [queryKey, page],
        (old: IListResponse<IComplain>) => {
          return {
            ...old,
            results: old.results.filter((item) => item.id !== id),
          };
        }
      );
      return { previousRequests };
    },
    onError: (err, data, context) => {
      console.log(data);
      console.error(err);
      toast({ variant: "destructive", title: "unable to delete the complain" });
      queryClient.setQueryData([queryKey, page], context?.previousRequests);
    },
  });

  const handleUserDeletion = () => {
    deleteUserMutation.mutate(complain.id, {
      onSuccess: () => {
        toast({
          variant: "success",
          title: `complain deleted successfully`,
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

export default ComplainsPage;
