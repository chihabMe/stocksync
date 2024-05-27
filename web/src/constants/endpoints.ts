

export const API = process.env.API


// auth routes 
export const loginEndpoint = API+"/auth/token/obtain/"
export const refreshEndpoint = API+"/auth/token/refresh/"
export const logoutEndpoint = API+"/auth/token/logout/"
export const meEndpoint = API+"/auth/me/"


// account routes
export const signupEndpoint = API+"/accounts/register/"

