class Expense {
  final String id;
  final String category;
  final double amount;
  final DateTime date;
  final String note;

  Expense({
    required this.id,
    required this.category,
    required this.amount,
    required this.date,
    required this.note,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        id: json['_id']?.toString() ?? '',
        category: json['category'] ?? '',
        amount: (json['amount'] is int)
            ? (json['amount'] as int).toDouble()
            : (json['amount'] ?? 0).toDouble(),
        date: DateTime.parse(json['date']),
        note: json['note'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'category': category,
        'amount': amount,
        'date': date.toIso8601String(),
        'note': note,
      };
}
