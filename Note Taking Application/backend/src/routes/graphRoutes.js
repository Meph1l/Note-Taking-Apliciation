import express from "express";
import graphController from "../controllers/graphController.js";
import authenticate from "../middleware/authMiddleware.js";

const router = express.Router();

router.use(authenticate);

router.get("/", graphController.getGraphsByUser);
router.get("/:graphId", graphController.getGraphById);
router.post("/preview", graphController.generatePreview);
router.post("/", graphController.saveGraph);
router.put("/:graphId", graphController.updateGraph);

export default router;
