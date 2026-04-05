import "./App.css";
import { BrowserRouter as Router, Routes, Route, Link, useLocation, useNavigate, Navigate } from "react-router-dom";
import Login from "./pages/Login";
import Register from "./pages/Register";
import Folders from "./pages/Folders";
import { getCurrentUser, logout } from "./Services/authApi";

function NavBar() {
  const location = useLocation();
  const navigate = useNavigate();
  const hideNav = ["/", "/login", "/register"].includes(location.pathname);

  if (hideNav) return null;

  const handleLogout = () => {
    logout();
    navigate("/login");
  };

  return (
    <nav className="app-nav">
      <span className="app-nav-logo">📓 NoteApp</span>
      <div className="app-nav-right">
        <div className="app-nav-links">
          <Link to="/folders" className={location.pathname === "/folders" ? "active" : ""}>
            📂 Folders
          </Link>
        </div>
        <button type="button" className="app-nav-logout" onClick={handleLogout}>
          Log Out
        </button>
      </div>
    </nav>
  );
}

function ProtectedRoute({ children }) {
  const currentUser = getCurrentUser();

  if (!currentUser) {
    return <Navigate to="/login" replace />;
  }

  return children;
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
          <Route
            path="/folders"
            element={
              <ProtectedRoute>
                <Folders />
              </ProtectedRoute>
            }
          />
        </Routes>
      </Router>
    </div>
  );
}

export default App;