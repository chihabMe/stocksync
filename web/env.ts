import { createEnv } from "@t3-oss/env-nextjs";
import { z } from "zod";

export const env = createEnv({
  server: {
    // DATABASE_URL: z.string().url(),
    // OPEN_AI_API_KEY: z.string().min(1),
    API: z.string(),
  },
  client: {
    // NEXT_PUBLIC_PUBLISHABLE_KEY: z.string().min(1),
    NEXT_PUBLIC_API: z.string(),
  },
  runtimeEnv: {
    // OPEN_AI_API_KEY: process.env.OPEN_AI_API_KEY,
    API: process.env.API,
    NEXT_PUBLIC_API: process.env.NEXT_PUBLIC_API,
  },
  // For Next.js >= 13.4.4, you only need to destructure client variables:
  // experimental__runtimeEnv: {
  //   NEXT_PUBLIC_PUBLISHABLE_KEY: process.env.NEXT_PUBLIC_PUBLISHABLE_KEY,
  // }
});
