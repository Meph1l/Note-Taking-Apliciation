import React, { useState } from "react";
import "./style.css";
import "bootstrap/dist/css/bootstrap.css";
import { useNavigate } from "react-router-dom";

const Register = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [errorMsg, setErrorMsg] = useState("");

  const navigate = useNavigate();

  const handleRegister = async () => {
    setErrorMsg("");

    if (!email || !password || !confirmPassword) {
      setErrorMsg("All fields are required.");
      return;
    }

    if (password !== confirmPassword) {
      setErrorMsg("Passwords do not match.");
      return;
    }

    try {
      const res = await fetch("http://localhost:8800/api/auth/register", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({
          email,
          password
        })
      });

      const data = await res.json();

      if (!res.ok) {
        setErrorMsg(data.error || "Registration failed.");
        return;
      }

      alert("Registration successful! Please log in.");
      navigate("/login");
    } catch (error) {
      console.error("Register error:", error);
      setErrorMsg("Server error. Please try again later.");
    }
  };

  return (
    <div className="login-page">
      <div className="login-card">
        <h1 className="login-title">Note Taking App</h1>
        <p className="login-sub">Note Taking Node Graph System</p>

        {errorMsg && <div id="error-msg" className="text-danger mb-3">{errorMsg}</div>}

        <div className="form-group" id="form1">
          <label className="form-label" htmlFor="email">Email</label>
          <input
            className="form-input"
            type="email"
            id="email"
            placeholder="note@gmail.com"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
        </div>

        <div className="form-group" id="form2">
          <label className="form-label" htmlFor="pass1">Password</label>
          <div className="password-wrap">
            <input
              className="form-input"
              type="password"
              id="pass1"
              placeholder="Enter your password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
          </div>
        </div>

        <div className="form-group" id="form3">
          <label className="form-label" htmlFor="pass2">Confirm Password</label>
          <div className="password-wrap">
            <input
              className="form-input"
              type="password"
              id="pass2"
              placeholder="Confirm Password"
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
            />
          </div>
        </div>

        <button className="btn btn-primary btn-full" id="register-btn" onClick={handleRegister}>
          Register
        </button>

        <hr className="login-divider" />
      </div>
    </div>
  );
};

export default Register;