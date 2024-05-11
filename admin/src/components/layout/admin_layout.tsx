import { Link, Outlet, useLocation } from 'react-router-dom'
import ProtectedWrapper from '../wrappers/ProtectedWrapper'
import { cn } from '@/lib/utils'
import Navbar from './navbar'
const links = [
    {
        path: "/admin",
        text: "statistics",
    },
    {
        path: "/admin/sellers",
        text: "sellers",
    },
    {
        path: "/admin/activation-requests",
        text: "activation requests",
    },
    {
        path: "/admin/clients",
        text: "clients",
    },
    {
        path: "/admin/categories",
        text: "categories",
    },
    {
        path: "/admin/complains",
        text: "complains",
    },
]
const AdminLayout = () => {
    return (
        <ProtectedWrapper>
            <Navbar />
            <main className='  mx-auto   container max-w-screen-2xl   flex min-h-screen'>
                <aside className='w-72    text-white'>
                    <div className='flex flex-col px-4 py-8 space-y-4 min-h-screen'>
                        {links.map(link => (
                            <NavItem to={link.path} text={link.text} />
                        ))}
                    </div>
                </aside>
                <div className='w-full bg-white p-8'>
                    <Outlet />
                </div>
            </main>
        </ProtectedWrapper>
    )
}

const NavItem = (props: { to: string, text: string }) => {
    const location = useLocation()
    const isActive = location.pathname == props.to
    return (
        <Link to={props.to} className={cn("w-full   text-gray-900 font-medium   py-2 px-4 hover:text-primary rounded-lg transition-colors duration-200", `${isActive && "bg-primary text-white hover:text-white   "}`)} >
            <span className='capitalize'>
                {props.text}
            </span>
        </Link>
    )
}
export default AdminLayout