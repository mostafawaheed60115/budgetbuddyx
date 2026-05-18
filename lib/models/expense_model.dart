class ExpenseModel {
  final String? id;
  final String category;
  final double amount;
  final String? date;
  final String? description;
  final bool isRecurring;

  ExpenseModel({
    this.id,
    required this.category,
    required this.amount,
    this.date,
    this.description,
    this.isRecurring = false,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      category: json['category'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: json['date']?.toString(),
      description: json['description']?.toString(),
      isRecurring: json['is_recurring'] ?? json['isRecurring'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'amount': amount,
      if (date != null) 'date': date,
      if (description != null && description!.isNotEmpty) 'description': description,
      'is_recurring': isRecurring,
    };
  }
}
