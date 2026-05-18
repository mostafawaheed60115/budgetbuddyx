class BudgetModel {
  final String? id;
  final String category;
  final double budgetLimit;
  final int month;
  final int year;
  final double? spent;

  BudgetModel({
    this.id,
    required this.category,
    required this.budgetLimit,
    required this.month,
    required this.year,
    this.spent,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      category: json['category'] ?? '',
      budgetLimit: (json['budget_limit'] ?? json['budgetLimit'] ?? 0).toDouble(),
      month: json['month'] ?? 1,
      year: json['year'] ?? DateTime.now().year,
      spent: (json['spent'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'budget_limit': budgetLimit,
      'month': month,
      'year': year,
    };
  }

  double get progress => budgetLimit > 0 ? (spent ?? 0) / budgetLimit : 0;
  double get remaining => budgetLimit - (spent ?? 0);
}
