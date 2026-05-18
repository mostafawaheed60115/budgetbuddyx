class SavingsModel {
  final String? id;
  final String goalName;
  final double targetAmount;
  final double currentAmount;
  final String? targetDate;

  SavingsModel({
    this.id,
    required this.goalName,
    required this.targetAmount,
    this.currentAmount = 0,
    this.targetDate,
  });

  factory SavingsModel.fromJson(Map<String, dynamic> json) {
    return SavingsModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      goalName: json['goal_name'] ?? json['goalName'] ?? '',
      targetAmount: (json['target_amount'] ?? json['targetAmount'] ?? 0).toDouble(),
      currentAmount: (json['current_amount'] ?? json['currentAmount'] ?? 0).toDouble(),
      targetDate: json['target_date']?.toString() ?? json['targetDate']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goal_name': goalName,
      'target_amount': targetAmount,
      'current_amount': currentAmount,
      if (targetDate != null) 'target_date': targetDate,
    };
  }

  double get progress => targetAmount > 0 ? currentAmount / targetAmount : 0;
  double get remaining => targetAmount - currentAmount;
}
