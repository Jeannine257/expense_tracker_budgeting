class Budget {
  final String id;
  final String category;
  final double limit;
  final String period; // "monthly" or "weekly"

  Budget({
    required this.id,
    required this.category,
    required this.limit,
    required this.period,
  });

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
        id: json['_id'],
        category: json['category'],
limit: json['limit'] is int ? (json['limit'] as int).toDouble() : json['limit'],
        period: json['period'],
      );

  Map<String, dynamic> toJson() => {
        'category': category,
        'limit': limit,
        'period': period,
      };
}
