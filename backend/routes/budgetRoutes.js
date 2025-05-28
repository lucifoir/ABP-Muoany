const express = require("express");
const router = express.Router();
const {
  upsertBudget,
  getBudgets,
  deleteBudget,
  updateBudgetById,
  deleteBudgetById,
} = require("../controllers/budgetController");
const { protect } = require("../middlewares/authMiddleware.js");

router.get("/", protect, getBudgets);
router.post("/", protect, upsertBudget);
router.put("/:id", protect, updateBudgetById);
router.delete('/:id', protect, deleteBudgetById);

module.exports = router;
