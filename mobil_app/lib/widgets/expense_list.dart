import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense_model.dart';

class ExpenseService {
  //static const String baseUrl = 'http://10.0.2.2:5000/api';
  static const String baseUrl = 'http://localhost:5000/api';

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
      final data = jsonDecode(res.body) as List;
      return data.map((e) => Expense.fromJson(e)).toList();
    }
    return [];
  }

  static Future<Expense> createExpense(Expense expense) async {
    final token = await _getToken();
    final res = await http.post(
      Uri.parse('$baseUrl/expenses'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(expense.toJson()),
    );
    return Expense.fromJson(jsonDecode(res.body));
  }

  static Future<void> updateExpense(String id, Expense expense) async {
    final token = await _getToken();
    await http.put(
      Uri.parse('$baseUrl/expenses/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(expense.toJson()),
    );
  }

  static Future<void> deleteExpense(String id) async {
    final token = await _getToken();
    await http.delete(
      Uri.parse('$baseUrl/expenses/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  static Future<Map<String, double>> getMonthlySummary() async {
    final token = await _getToken();
    final res = await http.get(
      Uri.parse('$baseUrl/expenses/summary'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return Map<String, double>.from(jsonDecode(res.body));
  }

  static Future<Map<String, double>> getTrends() async {
    final token = await _getToken();
    final res = await http.get(
      Uri.parse('$baseUrl/expenses/trends'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return Map<String, double>.from(jsonDecode(res.body));
  }
}
