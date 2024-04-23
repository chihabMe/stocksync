import { Link, Outlet } from 'react-router-dom'
import ProtectedWrapper from '../wrappers/Protected_wrapper'

const AdminLayout = () => {
    return (
        <ProtectedWrapper>
            <main>
                <aside>
                    <div className='flex flex-co space-y-4'>
                        <Link to="/admin/activation-requests">
                            activation requstw
                        </Link>
                        <Link to="/admin/sellers">
                            sellers
                        </Link>
                    </div>
                </aside>
                <div>
                    <Outlet />
                </div>
            </main>
        </ProtectedWrapper>
    )
}

export default AdminLayout