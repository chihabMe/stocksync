import {
    createBrowserRouter,
} from "react-router-dom";
import LoginPage from "@/pages/login";
import SellersPage from "@/pages/sellers";


export const router = createBrowserRouter([
    {
        path: "/",
        element: <LoginPage />,
    }, {
        path: "admin",
        children: [
            {
                path: "sellers",
                element: <SellersPage />
            }
        ]
    }


])