import { BrowserRouter, Routes, Route } from "react-router-dom";
import Login from "./pages/Login";
import Register from "./pages/Register";
import TagResearch from "./pages/TagResearch";

function App() {
  return (
    <div className="App">
      <BrowserRouter>
        <Routes>
          <Route path="/login" element={<Login/>}/>
          <Route path="/register" element={<Register/>}/>
          <Route path="/tag-research" element={<TagResearch/>}/>
        </Routes>
      </BrowserRouter>
    </div>
  );
}

export default App;
