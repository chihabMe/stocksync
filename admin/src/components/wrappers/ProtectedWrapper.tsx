import useAuth from "@/hooks/useAuth";
import { ReactNode } from "react";
import { Navigate, useNavigate } from "react-router-dom";
import { LoadingSpinner } from "../ui/loading-spinner";

const ProtectedWrapper = ({ children }: { children: ReactNode }) => {

    const { isLoading, user } = useAuth()
    const navigate = useNavigate()
    if (isLoading)
        return <div className="w-full min-h-screen flex justify-center items-center"><LoadingSpinner className="text-primary w-12 h-12" /></div>
    if (!user || user.user_type != "admin") {
        return <Navigate to="/" />
    }
    if (user.user_type != "admin")
        navigate("/errors/unauthorized")

    return (
        <>{children}</>
    )
}

export default ProtectedWrapper;