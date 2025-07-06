/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/expense_provider.dart';
import '../providers/budget_provider.dart';
import 'expense_form_screen.dart';
import 'budget_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
      final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
      await expenseProvider.fetchExpenses();
      await budgetProvider.fetchBudgets();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de chargement: \$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final expenses = Provider.of<ExpenseProvider>(context).expenses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text('Bienvenue, \dans votre tableau de bord', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  const Text('Dépenses récentes:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...expenses.take(5).map((e) => ListTile(
                        title: Text(e.category),
                        subtitle: Text('${e.note} - ${e.date.toLocal().toString().split(' ')[0]}'),
                        trailing: Text('${e.amount.toStringAsFixed(2)} FCFA'),
                      )),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Ajouter une dépense'),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExpenseFormScreen())),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Gérer les budgets'),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BudgetScreen())),
                  ),
                ],
              ),
            ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/expense_provider.dart';
import '../providers/budget_provider.dart';
//import '../models/expense_model.dart';
import 'expense_form_screen.dart';
import 'budget_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
      final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
      await expenseProvider.fetchExpenses();
      await budgetProvider.fetchBudgets();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de chargement: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final expenses = Provider.of<ExpenseProvider>(context).expenses;
    final budgetProvider = Provider.of<BudgetProvider>(context);
    final exceeded = budgetProvider.checkBudgetsExceeded(expenses);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text('Bienvenue dans votre tableau de bord', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),

                  // Alertes budgets dépassés
                  ...exceeded.entries.map((entry) {
                    if (entry.value) {
                      return Card(
                        color: Colors.red[100],
                        child: ListTile(
                          leading: const Icon(Icons.warning, color: Colors.red),
                          title: Text("Budget dépassé pour la catégorie : ${entry.key}"),
                          subtitle: const Text("Vous avez dépassé votre limite budgétaire."),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),

                  const SizedBox(height: 20),
                  const Text('Dépenses récentes:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...expenses.take(5).map((e) => ListTile(
                        title: Text(e.category),
                        subtitle: Text('${e.note} - ${e.date.toLocal().toString().split(' ')[0]}'),
                        trailing: Text('${e.amount.toStringAsFixed(2)} FCFA'),
                      )),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Ajouter une dépense'),
                    onPressed: () => Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const ExpenseFormScreen())),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Gérer les budgets'),
                    onPressed: () => Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const BudgetScreen())),
                  ),
                ],
              ),
            ),
    );
  }
}
