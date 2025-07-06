const Expense = require('../models/Expense');

exports.createExpense = async (req, res) => {
  const expense = await Expense.create({ ...req.body, userId: req.user });
  res.status(201).json(expense);
};

exports.getExpenses = async (req, res) => {
  const expenses = await Expense.find({ userId: req.user });
  res.json(expenses);
};

exports.updateExpense = async (req, res) => {
  const updated = await Expense.findOneAndUpdate(
    { _id: req.params.id, userId: req.user },
    req.body,
    { new: true }
  );
  res.json(updated);
};

exports.deleteExpense = async (req, res) => {
  await Expense.findOneAndDelete({ _id: req.params.id, userId: req.user });
  res.json({ message: 'Deleted' });
};
