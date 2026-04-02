import React from "react";
import "./style.css";
import 'bootstrap/dist/css/bootstrap.css';

const Login = () => {
  return (
    <div class="login-page">
    <div class="login-card">
        <h1 class="login-title">Note Taking App</h1>
        <p class="login-sub">Note Taking Node Graph System</p>

        <div id="error-msg"></div>

        <div class="form-group" id="form1">
        <label class="form-label" for="username">Username or Email</label>
        <input class="form-input" type="text" id="username" placeholder="note@gmail.com" maxlength="9" />
        </div>

        <div class="form-group" id ="form2">
        <label class="form-label" for="password">Password</label>
        <div class="password-wrap">
            <input class="form-input" type="password" id="password" placeholder="Enter your password"/>
            <button class="password-toggle" type="button" id="pwd-toggle" aria-label="Toggle password">
            </button>
        </div>
        </div>

        <button class="btn btn-primary btn-full" id="login-btn">Login</button>
        <a href="#" class="forgot-link">Forgot password?</a>
        <a href="register.html" class="forgot-link">Register</a>

        <hr class="login-divider" />
    </div>
    </div>
  );
};

export default Login;