import React from 'react'
import ReactDOM from 'react-dom/client'
import {
  RouterProvider,
} from "react-router-dom";
import { router } from "@/router/router.tsx"
import './index.css'
import { QueryClientProvider, QueryClient } from "@tanstack/react-query"

export const queryClient = new QueryClient()

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <QueryClientProvider client={queryClient}>
      <RouterProvider router={router} />
    </QueryClientProvider>
  </React.StrictMode>,
)
