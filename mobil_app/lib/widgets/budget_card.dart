import 'package:flutter/material.dart';
import '../models/budget_model.dart';

class BudgetCard extends StatelessWidget {
  final Budget budget;
  final double spentAmount; // total dépensé dans cette catégorie (passé depuis le parent)

  const BudgetCard({super.key, required this.budget, required this.spentAmount});

  @override
  Widget build(BuildContext context) {
    final percent = (spentAmount / budget.limit).clamp(0.0, 1.0);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              budget.category,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 6),
            LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey.shade300,
              color: percent > 1.0 ? Colors.red : Colors.green,
              minHeight: 8,
            ),
            SizedBox(height: 6),
            Text(
              "${spentAmount.toStringAsFixed(2)} / ${budget.limit.toStringAsFixed(2)} € (${budget.period})",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
