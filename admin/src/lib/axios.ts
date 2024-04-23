import { env } from "@/env";
import axios from "axios"
import { jwtDecode } from 'jwt-decode'

interface DecodedToken {
    exp: number;
    sub: string;
}
let accessToken = localStorage.get("access")

export const axioClient = axios.create({
    baseURL: env.VITE_SERVER_HOST,
    headers: {
        "Content-Type": "application/json",
    }
})

axioClient.interceptors.request.use(async (req) => {
    if (!accessToken)
        accessToken = localStorage.getItem("access") ?? null;
    let isValid = false
    if (accessToken) {
        const decodedToken: DecodedToken = jwtDecode(accessToken)
        const currentTime = Math.floor(Date.now() / 1000)
        isValid = decodedToken && decodedToken.exp < currentTime
    }
    if (isValid) {
        req.headers.Authorization = `Bearer ${accessToken}`
        return req
    }
    //the the acccess token doesn'nt exists or its invalid
    // we need to grab the refresh token from the local storage first
    const refresToken = localStorage.getItem("refresh")
    //if there is not stored refresh token we will return the req and let the request to be inavlid
    if (!refresToken)
        return req
    //if there is a refresh token we will try to fetch a new access token and 
    //update the local storage and inject it as a new header in the request
    try {
        const url = env.VITE_SERVER_HOST + refresToken
        const response = await axios.post(url, {
            token: refresToken
        })
        const accessToken = response.data.access
        localStorage.setItem("access", accessToken);
        req.headers.Authorization = `Bearer ${accessToken}`
        return req

    } catch (err) {
        console.error("token refresh fialed", err)
    }
    return req

})