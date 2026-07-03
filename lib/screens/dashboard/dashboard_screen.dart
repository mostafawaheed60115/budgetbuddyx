import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/income_provider.dart';
import '../../providers/expense_provider.dart';
import '../../providers/budget_provider.dart';
import '../../providers/savings_provider.dart';
import '../../providers/notification_provider.dart';
import '../widgets/summary_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final incomeProvider = context.read<IncomeProvider>();
    final expenseProvider = context.read<ExpenseProvider>();
    final budgetProvider = context.read<BudgetProvider>();
    final savingsProvider = context.read<SavingsProvider>();
    final notificationProvider = context.read<NotificationProvider>();

    await Future.wait([
      incomeProvider.fetchAll(),
      expenseProvider.fetchAll(),
      budgetProvider.fetchAll(),
      savingsProvider.fetchAll(),
      notificationProvider.fetchAll(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.dashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          Consumer<NotificationProvider>(
            builder: (context, notif, _) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () => Navigator.pushNamed(context, '/notifications'),
                  ),
                  if (notif.unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.danger,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${notif.unreadCount}',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Consumer4<IncomeProvider, ExpenseProvider, BudgetProvider, SavingsProvider>(
          builder: (context, income, expense, budget, savings, _) {
            if (income.isLoading && income.incomes.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final balance = income.totalIncome - expense.totalExpenses;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: AppStrings.totalIncome,
                        amount: income.totalIncome,
                        icon: Icons.trending_up,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SummaryCard(
                        title: AppStrings.totalExpenses,
                        amount: expense.totalExpenses,
                        icon: Icons.trending_down,
                        color: AppColors.danger,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SummaryCard(
                  title: AppStrings.balance,
                  amount: balance,
                  icon: Icons.account_balance,
                  color: balance >= 0 ? AppColors.primary : AppColors.danger,
                ),

                // Budgets Section
                if (budget.budgets.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    AppStrings.budgets,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...budget.budgets.map((b) {
                    final progress = b.progress.clamp(0.0, 1.0);
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  b.category,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                                Text(
                                  '${currencyFormat.format(b.spent ?? 0)} / ${currencyFormat.format(b.budgetLimit)}',
                                  style: const TextStyle(
                                    color: AppColors.secondaryText,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: AppColors.border,
                                color: progress > 0.9 ? AppColors.danger : AppColors.primary,
                                minHeight: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],

                // Savings Section
                if (savings.savings.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    AppStrings.savings,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...savings.savings.map((s) {
                    final progress = s.progress.clamp(0.0, 1.0);
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  s.goalName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                                Text(
                                  '${(progress * 100).toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    color: progress >= 1.0 ? AppColors.primary : AppColors.secondaryText,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${currencyFormat.format(s.currentAmount)} / ${currencyFormat.format(s.targetAmount)}',
                              style: const TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: AppColors.border,
                                color: AppColors.primary,
                                minHeight: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
