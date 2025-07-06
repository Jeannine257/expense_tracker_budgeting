const express = require('express');
const router = express.Router();
const protect = require('../middleware/authMiddleware');
const {
  createBudget,
  getBudgets,
  updateBudget,
  deleteBudget
} = require('../controllers/budgetController');

router.use(protect);

router.route('/')
  .post(createBudget)
  .get(getBudgets);

router.route('/:id')
  .put(updateBudget)
  .delete(deleteBudget);

module.exports = router;
