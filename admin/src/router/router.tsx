import {
    createBrowserRouter,
} from "react-router-dom";
import LoginPage from "@/pages/login";
import SellersPage from "@/pages/sellers";
import ErrorPage from "@/pages/errors/generate";
import ActivationRequests from "@/pages/activation_requests"
import AdminLayout from "@/components/layout/admin_layout";
import ClientsPage from "@/pages/clients";
import ProductsPage from "@/pages/products";
import ComplainsPage from "@/pages/complains";
import StatisticsPage from "@/pages/statistics";
import CategoriesPage from "@/pages/categories";
import DashboardPage from "@/pages/dashboard";


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
                path:"",
                element:<DashboardPage/>

            },

            {
                path: "sellers",
                element: <SellersPage />
            },
            {
                path: "clients",
                element: <ClientsPage />
            },

            {
                path: "categories",
                element: <CategoriesPage />
            },
            {
                path: "activation-requests",
                element: <ActivationRequests />
            },
            {
                path: "products",
                element: <ProductsPage />
            },
            {
                path: "complains",
                element: <ComplainsPage />
            },
            {
                path: "statistics",
                element: <StatisticsPage />
            },



        ]

    }

])