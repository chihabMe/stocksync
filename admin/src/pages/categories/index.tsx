import { useMutation, useQuery } from "@tanstack/react-query";

import { MoreHorizontal, PlusIcon } from "lucide-react";

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
import {
  deleteProductCategoryMutation,
  getProductsCategories,
} from "@/services/products.services";
import IProductCategory from "@/interfaces/IProductCategory";
import { AddCategoryModal } from "./components/AddCategoryModal";

const queryKey = "categories";
const CategoryPage = () => {
  const [openAddCategoryModal, setOpenAddCategoryModal] = useState(false);
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
    queryFn: () => getProductsCategories({ page }),
  });
  if (!isLoading && !data) return <h1>error</h1>;

  return (
    <Card className="">
      <CardHeader className="flex flex-row justify-between">
        <CardTitle>Categories</CardTitle>
        <AddCategoryModal
          open={openAddCategoryModal}
          setOpen={setOpenAddCategoryModal}
          page={page}
        />
        <Button onClick={() => setOpenAddCategoryModal(true)}>
          <PlusIcon className="w-5 h-5" />
        </Button>
      </CardHeader>
      <CardContent className="min-h-[65vh]">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>name</TableHead>
              <TableHead>name</TableHead>
              <TableHead className="hidden md:table-cell">parent</TableHead>
              <TableHead className="hidden md:table-cell">created at</TableHead>
              <TableHead>actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {isLoading && <ListSkelton />}
            {!isLoading &&
              data &&
              data.results.map((category) => (
                <ProductCategoryRow
                  key={category.id}
                  page={page}
                  category={category}
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
              Showing <strong>1-10</strong> of <strong>32</strong> categories
            </div>
          </>
        )}
      </CardFooter>
    </Card>
  );
};

const ProductCategoryRow = ({
  category,
  page,
}: {
  category: IProductCategory;
  page: number;
}) => {
  const created_at = new Date(category.created_at).toLocaleDateString("en-US", {
    day: "numeric",
    month: "short",
    year: "numeric",
    hour: "numeric",
    minute: "numeric",
  });
  return (
    <TableRow>
      <TableCell className="font-medium">{category.name}</TableCell>
      <TableCell className="hidden md:table-cell">
        {category.name ?? "None"}
      </TableCell>
      <TableCell className="hidden md:table-cell">
        {category?.parent?.name ?? "None"}
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
            <CategoryDeletionAction category={category} page={page} />
          </DropdownMenuContent>
        </DropdownMenu>
      </TableCell>
    </TableRow>
  );
};

const CategoryDeletionAction = ({
  category,
  page,
}: {
  category: IProductCategory;
  page: number;
}) => {
  const deleteUserMutation = useMutation({
    mutationFn: deleteProductCategoryMutation,
    onMutate: async (id) => {
      await queryClient.cancelQueries({
        queryKey: [queryKey, page],
      });
      const previousRequests = queryClient.getQueryData<
        IListResponse<IProductCategory>
      >([queryKey, page]);
      queryClient.setQueryData(
        [queryKey, page],
        (old: IListResponse<IProductCategory>) => {
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
      toast({ variant: "destructive", title: "unable to delete the category" });
      queryClient.setQueryData([queryKey, page], context?.previousRequests);
    },
  });

  const handleUserDeletion = () => {
    deleteUserMutation.mutate(category.id, {
      onSuccess: () => {
        toast({
          variant: "success",
          title: `category deleted successfully`,
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

export default CategoryPage;
