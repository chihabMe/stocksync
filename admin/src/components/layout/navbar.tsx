import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuTrigger } from "@/components/ui/dropdown-menu"
import { UserCircleIcon, Settings2Icon, LogOutIcon, User2Icon } from "lucide-react"
import { Button } from "@/components/ui/button"
import useAuth from "@/hooks/useAuth"
import { LoadingSpinner } from "../ui/loading-spinner"

const Navbar = () => {
    const { user, isLoading } = useAuth()
    if (isLoading || !user) return <LoadingSpinner />
    return (
        <nav className="flex justify-end container max-w-screen-2xl py-2">
            <ul>
                <li>
                    <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                            <Button className="rounded-full" size="icon" variant="secondary">
                                <UserCircleIcon className="h-6 w-6" />
                                <span className="sr-only">Toggle user menu</span>
                            </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="end" className="z-50 clear-start w-52 ">
                            <DropdownMenuLabel className="">{user.email}</DropdownMenuLabel>
                            <DropdownMenuSeparator />
                            <DropdownMenuItem className="cursor-pointer space-x-4 flex hover:!text-white hover:!bg-primary h-10 ">
                                <User2Icon className="w-5 h-5" />
                                <span>
                                    Profile
                                </span>
                            </DropdownMenuItem>
                            <DropdownMenuItem className="cursor-pointer space-x-4 flex hover:!text-white hover:!bg-primary h-10 ">
                                <Settings2Icon className="w-5 h-5" />
                                <span>
                                    Settings
                                </span>
                            </DropdownMenuItem>
                            <DropdownMenuSeparator />
                            <DropdownMenuItem className="hover:!bg-red-400 flex space-x-4  cursor-pointer hover:!text-white h-10">
                                <LogOutIcon className="w-5 h-5" />
                                <span>
                                    Logout
                                </span>
                            </DropdownMenuItem>
                        </DropdownMenuContent>
                    </DropdownMenu>
                </li>
            </ul>
        </nav>
    )

}

export default Navbar