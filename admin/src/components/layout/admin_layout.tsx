import { Link, Outlet, useLocation, useNavigate, useNavigation } from 'react-router-dom'
import ProtectedWrapper from '../wrappers/Protected_wrapper'
import { cn } from '@/lib/utils'
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
    {
        path: "/admin/products",
        text: "products",
    },
]
const AdminLayout = () => {
    return (
        <ProtectedWrapper>
            <main className='w-full mx-auto flex min-h-screen'>
                <aside className='w-64  text-white'>
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
        <Link to={props.to} className={cn("w-full   text-gray-900 font-medium   py-2 px-4 hover:text-primary rounded-lg transition-colors duration-200", `${isActive && "bg-primary text-white hover:text-white !shadow-lg  "}`)} >
            <span className='capitalize'>
                {props.text}
            </span>
        </Link>
    )
}
export default AdminLayout