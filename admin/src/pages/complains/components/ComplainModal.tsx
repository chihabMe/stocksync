import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { toast } from "@/components/ui/use-toast";
import IComplain from "@/interfaces/IComplain";
import IListResponse from "@/interfaces/IListResponse";
import { queryClient } from "@/main";
import { updateComplainStatusService } from "@/services/complains.services";
import { useMutation } from "@tanstack/react-query";

const queryKey = "complains";
export function ComplainModal({
  complain,
  open,
  page,
  setOpen,
}: {
  complain: IComplain;
  open: boolean;
  setOpen: (value: boolean) => void;
  page: number;
}) {
  const updateComplainStatusMutation = useMutation({
    mutationFn: updateComplainStatusService,
    onMutate: async (data) => {
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
            results: old.results.map((item) => {
              if (item.id != data.id) return item;
              return { ...item, status: data.status };
            }),
          };
        }
      );
      return { previousRequests };
    },
    onError: (err, _, context) => {
      console.error(err);
      toast({ variant: "destructive", title: "unable to update the complain" });
      queryClient.setQueryData([queryKey, page], context?.previousRequests);
    },
  });
  const handleCloseComplain = () => {
    updateComplainStatusMutation.mutate({
      id: complain.id,
      status: isClosed ? "pending" : "closed",
    });
  };
  const isClosed = complain.status == "closed";
  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogContent className="sm:max-w-[425px] ">
        <DialogHeader>
          <DialogTitle>client : {complain.client.user.username}</DialogTitle>
          <DialogDescription>complain details</DialogDescription>
        </DialogHeader>
        <div className="grid gap-4 py-4   ">
          <div className="flex gap-2">
            <h2 className="">Product name</h2>
            <h2>{complain.product.name}</h2>
          </div>
          <div className="flex gap-2">
            <h2 className="">Price</h2>
            <p>{complain.product.price}</p>
          </div>

          <div className="flex gap-2">
            <h2 className="">Client email</h2>
            <p>{complain.client.user.email}</p>
          </div>

          <div className="flex flex-col gap-2">
            <h2 className="">description</h2>
            <p>{complain.description}</p>
          </div>
        </div>
        <DialogFooter>
          <div className="flex gap-2">
            <Button
              variant={isClosed ? "outline" : "destructive"}
              onClick={handleCloseComplain}
            >
              {isClosed ? "open complain" : "close complain"}
            </Button>
            <Button type="submit">return money </Button>
          </div>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
