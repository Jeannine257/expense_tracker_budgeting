import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../services/expense_service.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  Future<void> fetchExpenses() async {
    try {
      _expenses = await ExpenseService.getExpenses();
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors du chargement des dépenses: $e');
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      final newExpense = await ExpenseService.createExpense(expense);
      _expenses.add(newExpense);
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors de l\'ajout de la dépense: $e');
    }
  }

  Future<void> updateExpense(String id, Expense updatedExpense) async {
    try {
      await ExpenseService.updateExpense(id, updatedExpense);
      final index = _expenses.indexWhere((e) => e.id == id);
      if (index != -1) {
        _expenses[index] = updatedExpense;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour de la dépense: $e');
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await ExpenseService.deleteExpense(id);
      _expenses.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors de la suppression de la dépense: $e');
    }
  }
}
