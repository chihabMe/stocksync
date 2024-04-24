import { useEffect, useState } from "react";
import { axiosClient } from "@/lib/axios"
import { currentAuthUserEndopint } from "@/utils/api_endpoints";
import { useNavigate } from "react-router-dom";
interface User {
    username: string;
    email: string
    user_type: "admin";
    image?: string;
}
export default function useAuth() {
    const [user, setUser] = useState<User | null>(null)
    const [isLoading, setIsLoading] = useState(true)
    const navigate = useNavigate()

    useEffect(() => {
        const fetchUser = async () => {
            setIsLoading(true)
            try {
                const response = await axiosClient.get<User>(currentAuthUserEndopint)
                if (response.data) {
                    setUser(response.data)
                }
            } catch (err) {
                console.error(err)
                setUser(null)
            }
            setIsLoading(false)
        }
        fetchUser()
    }, [])

    const logout = () => {
        localStorage.removeItem("accessToken")
        localStorage.removeItem("refreshToken")
        window.location.reload()

    }


    return { user, isLoading, logout }
}