import {
    createBrowserRouter,
} from "react-router-dom";
import LoginPage from "@/pages/login";
import SellersPage from "@/pages/sellers";
import UserActivation from "@/pages/activation_requests"
import ErrorPage from "@/pages/errors/generate";
import AdminLayout from "@/components/layout/admin_layout";


export const router = createBrowserRouter([

    {
        path: "/",
        element: <LoginPage />,
        errorElement: <ErrorPage />,
    },
    {
        path: "admin",
        element: <AdminLayout />,

        children: [
            {
                path: "sellers",
                element: <SellersPage />
            },
            {
                path: "activation-requests",
                element: <UserActivation />
            },



        ]

    }

])