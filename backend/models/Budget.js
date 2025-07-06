const mongoose = require('mongoose');

const budgetSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  category: String,
  limit: Number,
  period: { type: String, enum: ['monthly', 'weekly'] }
});

module.exports = mongoose.model('Budget', budgetSchema);
