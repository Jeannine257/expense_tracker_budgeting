/*import 'package:flutter/material.dart';
import '../models/budget_model.dart';
import '../services/budget_service.dart';

class BudgetProvider with ChangeNotifier {
  List<Budget> _budgets = [];

  List<Budget> get budgets => _budgets;

  Future<void> fetchBudgets() async {
    try {
      _budgets = await BudgetService.getBudgets();
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur budgets: $e');
    }
  }

  Future<void> addBudget(Budget budget) async {
    final newBudget = await BudgetService.createBudget(budget);
    _budgets.add(newBudget);
    notifyListeners();
  }

  Future<void> updateBudget(String id, Budget updatedBudget) async {
    await BudgetService.updateBudget(id, updatedBudget);
    final index = _budgets.indexWhere((b) => b.id == id);
    if (index != -1) {
      _budgets[index] = updatedBudget;
      notifyListeners();
    }
  }

  Future<void> deleteBudget(String id) async {
    await BudgetService.deleteBudget(id);
    _budgets.removeWhere((b) => b.id == id);
    notifyListeners();
  }
}
*/
import 'package:flutter/material.dart';
import '../models/budget_model.dart';
import '../models/expense_model.dart'; // ← assure-toi que ce fichier existe bien
import '../services/budget_service.dart';

class BudgetProvider with ChangeNotifier {
  List<Budget> _budgets = [];

  List<Budget> get budgets => _budgets;

  // 🔄 Récupère tous les budgets depuis l'API
  Future<void> fetchBudgets() async {
    try {
      _budgets = await BudgetService.getBudgets();
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur budgets: $e');
    }
  }

  // ➕ Ajouter un budget
  Future<void> addBudget(Budget budget) async {
    final newBudget = await BudgetService.createBudget(budget);
    _budgets.add(newBudget);
    notifyListeners();
  }

  // ✏️ Modifier un budget
  Future<void> updateBudget(String id, Budget updatedBudget) async {
    await BudgetService.updateBudget(id, updatedBudget);
    final index = _budgets.indexWhere((b) => b.id == id);
    if (index != -1) {
      _budgets[index] = updatedBudget;
      notifyListeners();
    }
  }

  // ❌ Supprimer un budget
  Future<void> deleteBudget(String id) async {
    await BudgetService.deleteBudget(id);
    _budgets.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  // ⚠️ Vérifie si des budgets sont dépassés
  Map<String, bool> checkBudgetsExceeded(List<Expense> expenses) {
    Map<String, double> totalParCategorie = {};
    for (var e in expenses) {
      totalParCategorie[e.category] =
          (totalParCategorie[e.category] ?? 0) + e.amount;
    }

    Map<String, bool> alertes = {};
    for (var budget in _budgets) {
      double total = totalParCategorie[budget.category] ?? 0;
      if (total > budget.limit) {
        alertes[budget.category] = true;
      }
    }
    return alertes;
  }
}
