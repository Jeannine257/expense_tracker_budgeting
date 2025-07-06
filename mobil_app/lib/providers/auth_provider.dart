import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String email, String password) async {
    final token = await AuthService.login(email, password);
    if (token != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      _user = await AuthService.getUserFromToken(token);
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password) async {
    await AuthService.register(name, email, password);
    await login(email, password);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _isAuthenticated = false;
    _user = null;
    notifyListeners();
  }

  Future<void> checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      _user = await AuthService.getUserFromToken(token);
      _isAuthenticated = _user != null;
      notifyListeners();
    }
  }
}
