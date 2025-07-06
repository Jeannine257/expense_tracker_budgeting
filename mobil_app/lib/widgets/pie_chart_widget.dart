import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, double> dataMap; // catégorie → montant

  const PieChartWidget({super.key, required this.dataMap});

  @override
  Widget build(BuildContext context) {
    final sections = dataMap.entries.map((entry) {
      final value = entry.value;
      final color = _getColor(entry.key);
      return PieChartSectionData(
        value: value,
        title: '${entry.key}\n${value.toStringAsFixed(1)}€',
        color: color,
        radius: 50,
        titleStyle: TextStyle(fontSize: 12, color: Colors.white),
      );
    }).toList();

    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 30,
          sectionsSpace: 2,
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Color _getColor(String category) {
    switch (category.toLowerCase()) {
      case 'alimentation':
        return Colors.blue;
      case 'transport':
        return Colors.orange;
      case 'loisirs':
        return Colors.purple;
      case 'santé':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
