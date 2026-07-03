import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/budget_provider.dart';
import '../widgets/empty_state.dart';

class BudgetListScreen extends StatefulWidget {
  const BudgetListScreen({super.key});

  @override
  State<BudgetListScreen> createState() => _BudgetListScreenState();
}

class _BudgetListScreenState extends State<BudgetListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BudgetProvider>().fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.budgets)),
      body: Consumer<BudgetProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.budgets.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.budgets.isEmpty) {
            return const EmptyState(
              icon: Icons.account_balance_wallet,
              message: 'No budgets yet',
            );
          }
          return RefreshIndicator(
            onRefresh: provider.fetchAll,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.budgets.length,
              itemBuilder: (context, index) {
                final budget = provider.budgets[index];
                final progress = budget.progress.clamp(0.0, 1.0);

                return Slidable(
                  endActionPane: ActionPane(
                    motion: const BehindMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Budget'),
                              content: const Text('Are you sure?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppStrings.cancel)),
                                TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(AppStrings.delete, style: const TextStyle(color: AppColors.danger))),
                              ],
                            ),
                          );
                          if (confirm == true && budget.id != null) {
                            provider.delete(budget.id!);
                          }
                        },
                        backgroundColor: AppColors.danger,
                        foregroundColor: AppColors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: Card(
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(context, '/budget/form', arguments: budget),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  budget.category,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '${budget.month}/${budget.year}',
                                  style: const TextStyle(
                                    color: AppColors.secondaryText,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${currencyFormat.format(budget.spent ?? 0)} / ${currencyFormat.format(budget.budgetLimit)}',
                                  style: const TextStyle(
                                    color: AppColors.secondaryText,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  '${(progress * 100).toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    color: progress > 0.9 ? AppColors.danger : AppColors.primary,
                                    fontWeight: FontWeight.w600,
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
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        onPressed: () => Navigator.pushNamed(context, '/budget/form'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
