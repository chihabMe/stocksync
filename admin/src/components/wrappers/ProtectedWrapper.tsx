import useAuth from "@/hooks/useAuth";
import { ReactNode } from "react";
import { useNavigate } from "react-router-dom";

const ProtectedWrapper = ({ children }: { children: ReactNode }) => {

    const { isLoading, user } = useAuth()
    const navigate = useNavigate()
    if (isLoading) return <h1>loading</h1>
    if (!user || user.user_type != "admin") {
        navigate("/errors/unauthorized")
        return <></>
    }

    return (
        <>{children}</>
    )
}

export default ProtectedWrapper;