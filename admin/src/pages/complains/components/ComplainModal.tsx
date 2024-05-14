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
import { Label } from "@/components/ui/label";
import IComplain from "@/interfaces/IComplain";

export function ComplainModal({
  complain,
  open,
  setOpen,
}: {
  complain: IComplain;
  open: boolean;
  setOpen: (value:boolean) => void;
}) {
  return (
    <Dialog open={open}  onOpenChange={setOpen}  >
      <DialogContent className="sm:max-w-[425px] " >
        <DialogHeader >
          <DialogTitle>client : {complain.client.user.username}</DialogTitle>
          <DialogDescription>{complain.description}</DialogDescription>
        </DialogHeader>
        <div className="grid gap-4 py-4   ">
          <div className="flex gap-2">
            <h2 className="">
             Product name   
            </h2>
            <h2>
              {complain.product.name}
            </h2>
          </div>

          <div className="flex gap-2">
            <h2 className="">
              Price
            </h2>
            <p>
              {complain.product.price}
            </p>
          </div>

          <div className="flex gap-2">
            <h2 className="">
              Client  email
            </h2>
            <p>
              {complain.client.user.email}
            </p>
          </div>
        </div>
        <DialogFooter>
          <div className="flex gap-2">
          <Button variant="destructive" >close complain</Button>
          <Button type="submit">return money </Button>
          </div>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
