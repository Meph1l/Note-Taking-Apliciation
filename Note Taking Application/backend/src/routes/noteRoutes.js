import express from "express";
const router = express.Router();

import noteController from "../controllers/noteController.js";
import authenticate from "../middleware/authMiddleware.js";

router.use(authenticate);

// GET /api/notes
router.get("/", noteController.getNotesByUser);

// GET /api/notes/unfoldered
router.get("/unfoldered", noteController.getUnfolderedNotesByUser);

// GET /api/notes/folder/:folderId
router.get("/folder/:folderId", noteController.getNotesByFolder);

// GET /api/notes/:noteId
router.get("/:noteId", noteController.getNoteById);

// POST /api/notes
router.post("/", noteController.createNote);

// PUT /api/notes/:noteId
router.put("/:noteId", noteController.updateNote);

// DELETE /api/notes/:noteId
router.delete("/:noteId", noteController.deleteNote);

// PUT /api/notes/:noteId/move
router.put("/:noteId/move", noteController.moveNoteToFolder);

export default router;