const API_V1 = "/api/v1";

/// server api routes 

// auth routes
/// auth  cookies
export const loginEndpoint = API_V1 + "/auth/login/";
export const refreshAuthCookieEndpoint = API_V1 + "/auth/refresh/";
//

export const refreshEndpoint = API_V1 + "/auth/token/refresh/";
export const logoutEndpoint = API_V1 + "/auth/token/logout/";
export const meEndpoint = API_V1 + "/auth/me/";
export const verifyTokenEndpoints = API_V1+"/auth/token/verify/"


// account routes
export const signupEndpoint = API_V1+ "/accounts/register/";

//next api routes
export const loginNotifyNextServer = "/api/auth/login/";
export const notifyRefreshNextServerEndpoint = "/api/auth/refresh/";
