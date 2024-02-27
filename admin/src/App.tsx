import { useState } from 'react'
import './App.css'
import { Button } from './components/ui/button'

function App() {
  const [count, setCount] = useState(0)

  return (
    <div>
      <Button onClick={()=>setCount(p=>p+1)}>click me </Button>
      <h1>{count}</h1>
    </div>
  )
}

export default App
