import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/budget_model.dart';

class BudgetService {
  static const String baseUrl = 'http://localhost:5000/api'; // adapte si nécessaire

  static Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  static Future<List<Budget>> getBudgets() async {
    final token = await _getToken();
    final res = await http.get(
      Uri.parse('$baseUrl/budgets'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode != 200) {
      throw Exception('Erreur lors du chargement des budgets');
    }

    final data = jsonDecode(res.body);
    final List<dynamic> budgets = data is List ? data : data['budgets'];
    return budgets.map((b) => Budget.fromJson(b)).toList();
  }

  static Future<Budget> createBudget(Budget budget) async {
    final token = await _getToken();
    final res = await http.post(
      Uri.parse('$baseUrl/budgets'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(budget.toJson()),
    );

    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception('Erreur lors de la création du budget');
    }

    return Budget.fromJson(jsonDecode(res.body));
  }

  static Future<void> updateBudget(String id, Budget budget) async {
    final token = await _getToken();
    final res = await http.put(
      Uri.parse('$baseUrl/budgets/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(budget.toJson()),
    );

    if (res.statusCode != 200) {
      throw Exception('Erreur lors de la mise à jour du budget');
    }
  }

  static Future<void> deleteBudget(String id) async {
    final token = await _getToken();
    final res = await http.delete(
      Uri.parse('$baseUrl/budgets/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Erreur lors de la suppression du budget');
    }
  }
}
