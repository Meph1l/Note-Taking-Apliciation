import express from "express";
import tagController from "../controllers/tagController.js";
import authenticate from "../middleware/authMiddleware.js";

const router = express.Router();

router.use(authenticate);

router.get("/", tagController.getTagsByUser);
router.get("/note/:noteId", tagController.getTagsByNote);
router.get("/:tagId/notes", tagController.getNotesByTag);
router.post("/", tagController.createTag);
router.put("/:tagId", tagController.updateTag);
router.delete("/:tagId/notes/:noteId", tagController.removeTagFromNote);

export default router;
