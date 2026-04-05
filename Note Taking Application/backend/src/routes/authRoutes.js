import express from "express";
const router = express.Router();

import authController from "../controllers/authController.js";

// POST /api/auth/login
router.post("/login", authController.login);

// POST /api/auth/register
router.post("/register", authController.register);

export default router;