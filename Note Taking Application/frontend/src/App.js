import { BrowserRouter as Router, Routes, Route, Link, useLocation } from "react-router-dom";
import Login from "./pages/Login";
import Register from "./pages/Register";
import Folders from "./pages/Folders";

function NavBar() {
  const location = useLocation();
  const hideNav = ["/", "/login", "/register"].includes(location.pathname);

  if (hideNav) return null;

  return (
    <nav className="app-nav">
      <span className="app-nav-logo">📓 NoteApp</span>
      <div className="app-nav-links">
        <Link to="/folders" className={location.pathname === "/folders" ? "active" : ""}>
          📂 Folders
        </Link>
      </div>
    </nav>
  );
}

function App() {
  return (
    <div className="App">
      <Router>
        <NavBar />
        <Routes>
          <Route path="/" element={<Login />} />
          <Route path="/login" element={<Login />} />
          <Route path="/register" element={<Register />} />
          <Route path="/folders" element={<Folders />} />
        </Routes>
      </Router>
    </div>
  );
}

export default App;