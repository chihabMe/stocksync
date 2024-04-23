import useAuth from "@/hooks/useAuth"

const SellersPage = () => {
  const { isLoading, user } = useAuth()
  if (isLoading) return <h1>loading</h1>
  return (
    <main>

      <div>sellers_page</div>
      <div>sellers_page</div>
      {JSON.stringify(user)}
    </main>
  )
}

export default SellersPage