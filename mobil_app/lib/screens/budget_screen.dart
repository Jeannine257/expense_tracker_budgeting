import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/budget_model.dart';
import '../providers/budget_provider.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  String _category = 'Alimentation';
  double _limit = 0;
  String _period = 'monthly';

  final List<String> _categories = [
    'Alimentation',
    'Transport',
    'Loisirs',
    'Santé',
    'Factures',
    'Loyer',
    'Éducation',
    'Voyages',
    'Épargne',
    'Autre',
  ];

  final List<String> _periods = ['monthly', 'weekly'];

  bool _isEditing = false;
  String? _editingBudgetId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BudgetProvider>(context, listen: false).fetchBudgets();
    });
  }

  void _startEditing(Budget budget) {
    setState(() {
      _isEditing = true;
      _editingBudgetId = budget.id;
      _category = budget.category;
      _limit = budget.limit;
      _period = budget.period;
    });
  }

  void _resetForm() {
    setState(() {
      _isEditing = false;
      _editingBudgetId = null;
      _category = _categories.first;
      _limit = 0;
      _period = 'monthly';
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final budget = Budget(
      id: _editingBudgetId ?? '',
      category: _category,
      limit: _limit,
      period: _period,
    );

    final provider = Provider.of<BudgetProvider>(context, listen: false);

    if (_isEditing) {
      await provider.updateBudget(_editingBudgetId!, budget);
    } else {
      await provider.addBudget(budget);
    }

    _resetForm();
  }

  @override
  Widget build(BuildContext context) {
    final budgets = Provider.of<BudgetProvider>(context).budgets;

    return Scaffold(
      appBar: AppBar(title: const Text("Budgets")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _category,
                    decoration: const InputDecoration(labelText: "Catégorie"),
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) => setState(() => _category = val!),
                  ),
                  TextFormField(
                    initialValue: _limit > 0 ? _limit.toString() : '',
                    decoration: const InputDecoration(labelText: "Limite"),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Limite obligatoire";
                      final value = double.tryParse(v);
                      if (value == null || value <= 0) {
                        return "Entrez une limite valide (> 0)";
                      }
                      return null;
                    },
                    onSaved: (v) => _limit = double.parse(v!),
                  ),
                  DropdownButtonFormField<String>(
                    value: _period,
                    decoration: const InputDecoration(labelText: "Période"),
                    items: _periods
                        .map((p) =>
                            DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (val) => setState(() => _period = val!),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text(_isEditing ? "Modifier" : "Ajouter"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: budgets.isEmpty
                  ? const Center(
                      child: Text(
                        "Aucun budget enregistré",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: budgets.length,
                      itemBuilder: (context, index) {
                        final b = budgets[index];
                        return ListTile(
                          title:
                              Text("${b.category} - ${b.limit.toStringAsFixed(2)}"),
                          subtitle: Text("Période : ${b.period}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _startEditing(b),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => Provider.of<BudgetProvider>(
                                  context,
                                  listen: false,
                                ).deleteBudget(b.id),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
