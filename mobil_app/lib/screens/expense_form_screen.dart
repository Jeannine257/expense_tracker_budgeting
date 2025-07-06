import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense_model.dart';
import '../providers/expense_provider.dart';

class ExpenseFormScreen extends StatefulWidget {
  final Expense? expense;

  const ExpenseFormScreen({super.key, this.expense});

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _category;
  late double _amount;
  late DateTime _date;
  String _note = '';

  final List<String> _categories = [
    'Alimentation', 'Transport', 'Loisirs', 'Santé',
    'Loyer', 'Factures', 'Education', 'Voyages', 'Epargne', 'Autre'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _category = widget.expense!.category;
      _amount = widget.expense!.amount;
      _date = widget.expense!.date;
      _note = widget.expense!.note;
    } else {
      _category = _categories.first;
      _amount = 0;
      _date = DateTime.now();
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final newExpense = Expense(
      id: widget.expense?.id ?? '',
      category: _category,
      amount: _amount,
      date: _date,
      note: _note,
    );

    final provider = Provider.of<ExpenseProvider>(context, listen: false);

    if (widget.expense == null) {
      await provider.addExpense(newExpense);
    } else {
      await provider.updateExpense(newExpense.id, newExpense);
    }

    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    if (widget.expense != null) {
      final provider = Provider.of<ExpenseProvider>(context, listen: false);
      await provider.deleteExpense(widget.expense!.id);
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expense != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Modifier dépense" : "Nouvelle dépense"),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Confirmer'),
                    content: const Text('Supprimer cette dépense ?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Annuler')),
                      ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Supprimer')),
                    ],
                  ),
                );
                if (confirm == true) await _delete();
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: "Catégorie"),
                items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (val) => setState(() => _category = val!),
              ),
              TextFormField(
                initialValue: _amount > 0 ? _amount.toString() : '',
                decoration: const InputDecoration(labelText: "Montant"),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return "Montant obligatoire";
                  if (double.tryParse(v) == null) return "Montant invalide";
                  return null;
                },
                onSaved: (v) => _amount = double.parse(v!),
              ),
              ListTile(
                title: Text("Date : ${_date.toLocal().toString().split(' ')[0]}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              TextFormField(
                initialValue: _note,
                decoration: const InputDecoration(
                  labelText: "Note",
                  prefixIcon: Icon(Icons.comment),
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                onSaved: (v) => _note = v ?? '',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isEditing ? "Modifier" : "Ajouter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
