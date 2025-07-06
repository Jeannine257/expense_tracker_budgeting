import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense_model.dart';

class ExpenseService {
  static const String baseUrl = 'http://localhost:5000/api'; // adapte selon ta plateforme

  static Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  static Future<List<Expense>> getExpenses() async {
    final token = await _getToken();
    final res = await http.get(
      Uri.parse('$baseUrl/expenses'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);

      // Si le backend renvoie {"expenses": [...]}, on extrait la liste
      final List<dynamic> data = decoded is List
          ? decoded
          : (decoded['expenses'] ?? []);

      return data.map((e) => Expense.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors du chargement des dépenses');
    }
  }

  static Future<Expense> createExpense(Expense expense) async {
    final token = await _getToken();
    final res = await http.post(
      Uri.parse('$baseUrl/expenses'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(expense.toJson()),
    );

    if (res.statusCode == 201 || res.statusCode == 200) {
      return Expense.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Erreur lors de la création de la dépense');
    }
  }

  static Future<void> updateExpense(String id, Expense expense) async {
    final token = await _getToken();
    final res = await http.put(
      Uri.parse('$baseUrl/expenses/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(expense.toJson()),
    );

    if (res.statusCode != 200) {
      throw Exception('Erreur lors de la mise à jour de la dépense');
    }
  }

  static Future<void> deleteExpense(String id) async {
    final token = await _getToken();
    final res = await http.delete(
      Uri.parse('$baseUrl/expenses/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Erreur lors de la suppression de la dépense');
    }
  }

  static Future<Map<String, double>> getMonthlySummary() async {
    final token = await _getToken();
    final res = await http.get(
      Uri.parse('$baseUrl/expenses/summary'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      return Map<String, double>.from(jsonDecode(res.body));
    } else {
      throw Exception('Erreur lors de la récupération du résumé mensuel');
    }
  }

  static Future<Map<String, double>> getTrends() async {
    final token = await _getToken();
    final res = await http.get(
      Uri.parse('$baseUrl/expenses/trends'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      return Map<String, double>.from(jsonDecode(res.body));
    } else {
      throw Exception('Erreur lors de la récupération des tendances');
    }
  }
}
