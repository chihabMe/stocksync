import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import IComplain from "@/interfaces/IComplain";
import { ReactNode } from "react";

export function ComplainModal({
  complain,
  open,
  colseModal,
}: {
  complain: IComplain;
  open: boolean;
  closeModal: () => void;
}) {
  return (
    <Dialog open={open} >
      <DialogContent className="sm:max-w-[425px]" >
        <DialogHeader >
          <DialogTitle>{complain.client.user.username}</DialogTitle>
          <DialogDescription>{complain.description}</DialogDescription>
        </DialogHeader>
        <div className="grid gap-4 py-4">
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="name" className="text-right">
              {complain.product.name}
            </Label>
            <Input
              id="name"
              defaultValue="Pedro Duarte"
              className="col-span-3"
            />
          </div>
          <div className="grid grid-cols-4 items-center gap-4">
            <Label htmlFor="username" className="text-right">
              Username
            </Label>
            <Input
              id="username"
              defaultValue="@peduarte"
              className="col-span-3"
            />
          </div>
        </div>
        <DialogFooter>
          <Button type="submit">Save changes</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
