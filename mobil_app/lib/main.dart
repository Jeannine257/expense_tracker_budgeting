import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobil_app/providers/auth_provider.dart';
import 'package:mobil_app/providers/expense_provider.dart';
import 'package:mobil_app/providers/budget_provider.dart';
import 'package:mobil_app/screens/login_screen.dart';
import 'package:mobil_app/screens/register_screen.dart';
import 'package:mobil_app/screens/dashboard_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
    theme: ThemeData(
  fontFamily: 'Arial',
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
),

      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
