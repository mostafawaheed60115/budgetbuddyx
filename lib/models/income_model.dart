class IncomeModel {
  final String? id;
  final String source;
  final double amount;
  final String? date;
  final String? description;

  IncomeModel({
    this.id,
    required this.source,
    required this.amount,
    this.date,
    this.description,
  });

  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      source: json['source'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: json['date']?.toString(),
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'amount': amount,
      if (date != null) 'date': date,
      if (description != null && description!.isNotEmpty) 'description': description,
    };
  }
}
