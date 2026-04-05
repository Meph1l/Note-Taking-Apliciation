import express from "express";
const router = express.Router();

import folderController from "../controllers/folderController.js";
import authenticate from "../middleware/authMiddleware.js";

router.use(authenticate);

// GET /api/folders
router.get("/", folderController.getFoldersByUser);

// GET /api/folders/:folderId
router.get("/:folderId", folderController.getFolderById);

// POST /api/folders
router.post("/", folderController.createFolder);

// PUT /api/folders/:folderId
router.put("/:folderId", folderController.renameFolder);

// DELETE /api/folders/:folderId
router.delete("/:folderId", folderController.deleteFolder);

export default router;