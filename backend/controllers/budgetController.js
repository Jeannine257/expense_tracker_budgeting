const Budget = require('../models/Budget');

exports.createBudget = async (req, res) => {
  const budget = await Budget.create({ ...req.body, userId: req.user });
  res.status(201).json(budget);
};

exports.getBudgets = async (req, res) => {
  const budgets = await Budget.find({ userId: req.user });
  res.json(budgets);
};

exports.updateBudget = async (req, res) => {
  const updated = await Budget.findOneAndUpdate(
    { _id: req.params.id, userId: req.user },
    req.body,
    { new: true }
  );
  res.json(updated);
};

exports.deleteBudget = async (req, res) => {
  await Budget.findOneAndDelete({ _id: req.params.id, userId: req.user });
  res.json({ message: 'Deleted' });
};
