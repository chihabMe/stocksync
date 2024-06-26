"use client";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { ChangeEvent, FormEvent, useEffect, useState } from "react";
import { LoadingSpinner } from "@/components/ui/loading-spinner";
import { loginServices, signupServices } from "@/servies/auth.servies";
import FormikInput from "@/components/ui/FormikInput";
import { Formik } from "formik";
import { toFormikValidationSchema } from "zod-formik-adapter";
import { loginSchema, signupSchema } from "@/app/schemas/auth.schema";
import { useRouter } from "next/navigation";
import { AxiosError } from "axios";
import { useToast } from "@/components/ui/use-toast";

const initialForm = {
  email: "",
  username: "",
  password: "",
  password2: "",
};
export default function SignUpPage() {
  const router = useRouter();
  const { toast } = useToast();
  useEffect(() => {
    toast({
      title: "Welcome",
      description:
        "you can create an account by providing a valid email and password",
    });
  }, []);
  return (
    <main className="w-full min-h-screen flex justify-center items-center">
      <Card className="w-full max-w-md">
        <CardHeader>
          <CardTitle className="text-2xl">Signup </CardTitle>
          <CardDescription>
            you can create an account by providing a valid email and password
          </CardDescription>
        </CardHeader>
        <CardContent className="py-4">
          <Formik
            initialValues={initialForm}
            validationSchema={toFormikValidationSchema(signupSchema)}
            validateOnBlur={true}
            onSubmit={async (values, actions) => {
              try {
                const response = await signupServices(values);
                if (response && response.status == 201) {
                  router.push("/auth/login");
                  toast({
                    title: "Account created",
                    description: "you can now login to your account",
                  });
                } else {
                }
              } catch (err) {
                console.error(err);
                if (err instanceof AxiosError)
                  actions.setErrors(err.response?.data);
              }
              actions.setSubmitting(false);
            }}
          >
            {(props) => (
              <form onSubmit={props.handleSubmit}>
                <div className="grid w-full items-center space-y-6">
                  <div className="flex flex-col space-y-2">
                    <FormikInput name="username" label="username" type="text" />
                  </div>
                  <div className="flex flex-col space-y-2">
                    <FormikInput name="email" label="email" type="email" />
                  </div>

                  <div className="flex flex-col space-y-2">
                    <FormikInput
                      name="password"
                      label="password"
                      type="password"
                    />
                  </div>

                  <div className="flex flex-col space-y-2">
                    <FormikInput
                      name="password2"
                      label="confirm password"
                      type="password"
                    />
                  </div>
                  <Button
                    type="submit"
                    className="flex justify-center relative "
                  >
                    {!props.isSubmitting && <span>sign up</span>}
                    {props.isSubmitting && (
                      <LoadingSpinner className="w-4 h-4 " />
                    )}
                  </Button>
                </div>
              </form>
            )}
          </Formik>
        </CardContent>
      </Card>
    </main>
  );
}
