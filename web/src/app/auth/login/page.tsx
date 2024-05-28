"use client";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { ChangeEvent, FormEvent, useState } from "react";
import { LoadingSpinner } from "@/components/ui/loading-spinner";
import { loginServices } from "@/servies/auth.servies";
import FormikInput from "@/components/ui/FormikInput";
import { Formik } from "formik";
import { toFormikValidationSchema } from "zod-formik-adapter";
import { loginSchema } from "@/app/schemas/auth.schema";
import { useRouter } from "next/navigation";

const initialForm = {
  email: "",
  password: "",
};
export default function LoginPage() {
  const router = useRouter();
  return (
    <main className="w-full min-h-screen flex justify-center items-center">
      <Card className="w-full max-w-md">
        <CardHeader>
          <CardTitle className="text-2xl">Signin</CardTitle>
          <CardDescription>
            to access your account you have to provide a valid email and
            password
          </CardDescription>
        </CardHeader>
        <CardContent className="py-4">
          <Formik
            initialValues={initialForm}
            validationSchema={toFormikValidationSchema(loginSchema)}
            validateOnBlur={true}
            onSubmit={async (values, actions) => {
              try {
                const response = await loginServices(
                  values["email"],
                  values["password"]
                );
                console.log(response);
                if (response && response.status == 200) {
                  router.push("/");
                }
              } catch (err) {
                console.error(err);
              }
              actions.setSubmitting(false);
            }}
          >
            {(props) => (
              <form onSubmit={props.handleSubmit}>
                <div className="grid w-full items-center space-y-6">
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
                  <Button
                    type="submit"
                    className="flex justify-center relative "
                  >
                    {!props.isSubmitting && <span>login</span>}
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
