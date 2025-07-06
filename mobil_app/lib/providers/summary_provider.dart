import 'package:flutter/material.dart';
import '../services/expense_service.dart';

class SummaryProvider with ChangeNotifier {
  Map<String, double> _monthlySummary = {};
  Map<String, double> _categoryTrends = {};

  Map<String, double> get monthlySummary => _monthlySummary;
  Map<String, double> get categoryTrends => _categoryTrends;

  Future<void> fetchMonthlySummary() async {
    _monthlySummary = await ExpenseService.getMonthlySummary();
    notifyListeners();
  }

  Future<void> fetchTrends() async {
    _categoryTrends = await ExpenseService.getTrends();
    notifyListeners();
  }
}
