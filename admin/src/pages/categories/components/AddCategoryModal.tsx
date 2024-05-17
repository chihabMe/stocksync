import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { toast } from "@/components/ui/use-toast";
import { queryClient } from "@/main";
import { addCategoryMutationService } from "@/services/products.services";
import { useMutation } from "@tanstack/react-query";
import { ChangeEvent, FormEvent, useState } from "react";

const queryKey = "categories";
export function AddCategoryModal({
  open,
  page,
  setOpen,
}: {
  open: boolean;
  setOpen: (value: boolean) => void;
  page: number;
}) {
  const [form, setForm] = useState({ name: "" });
  const handleChange = (e: ChangeEvent<HTMLInputElement>) => {
    setForm((prev) => ({ ...prev, [e.target.name]: e.target.value }));
  };
  const addCategoryMutation = useMutation({
    mutationFn: addCategoryMutationService,
    // onMutate: async (data) => {
    //   await queryClient.cancelQueries({
    //     queryKey: [queryKey, page],
    //   });
    //   const previousRequests = queryClient.getQueryData<
    //     IListResponse<IProductCategory>
    //   >([queryKey, page]);
    //   queryClient.setQueryData(
    //     [queryKey, page],
    //     (old: IListResponse<IComplain>) => {
    //       return {
    //         ...old,
    //         results: [
    //           ...old.results,
    //           { id: Math.random().toString(), name: data.name },
    //         ],
    //       };
    //     }
    //   );
    //   return { previousRequests };
    // },
    onError: (err, _, context) => {
      console.error(err);
      toast({ variant: "destructive", title: "unable to add category" });
      //   queryClient.setQueryData([queryKey, page], context?.previousRequests);
    },
    onSuccess: () => {
      toast({ variant: "success", title: "added new category" });
      setOpen(false);
      queryClient.invalidateQueries({ queryKey: [queryKey, page] });
    },
  });
  const handleAddCategorySubmit = (e: FormEvent) => {
    e.preventDefault();
    console.log("click");
    addCategoryMutation.mutate(form);
  };
  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogContent className="sm:max-w-[425px] ">
        <DialogHeader>
          <DialogTitle>Add Category </DialogTitle>
          <DialogDescription className="py-1">
            you can add new categories
          </DialogDescription>
        </DialogHeader>
        <Input onChange={handleChange} name="name" value={form["name"]} />
        <DialogFooter>
          <div className="flex gap-2">
            <form onSubmit={handleAddCategorySubmit}>
              <Button type="submit" className="my-2">
                save
              </Button>
            </form>
          </div>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
