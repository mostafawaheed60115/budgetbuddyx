import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/savings_provider.dart';
import '../widgets/empty_state.dart';

class SavingsListScreen extends StatefulWidget {
  const SavingsListScreen({super.key});

  @override
  State<SavingsListScreen> createState() => _SavingsListScreenState();
}

class _SavingsListScreenState extends State<SavingsListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SavingsProvider>().fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.savings)),
      body: Consumer<SavingsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.savings.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.savings.isEmpty) {
            return const EmptyState(
              icon: Icons.savings,
              message: 'No savings goals yet',
            );
          }
          return RefreshIndicator(
            onRefresh: provider.fetchAll,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.savings.length,
              itemBuilder: (context, index) {
                final saving = provider.savings[index];
                final progress = saving.progress.clamp(0.0, 1.0);

                return Slidable(
                  endActionPane: ActionPane(
                    motion: const BehindMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Savings Goal'),
                              content: const Text('Are you sure?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(AppStrings.cancel)),
                                TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text(AppStrings.delete, style: TextStyle(color: AppColors.danger))),
                              ],
                            ),
                          );
                          if (confirm == true && saving.id != null) {
                            provider.delete(saving.id!);
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
                      onTap: () => Navigator.pushNamed(context, '/savings/form', arguments: saving),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    saving.goalName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
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
                              '${currencyFormat.format(saving.currentAmount)} / ${currencyFormat.format(saving.targetAmount)}',
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
        onPressed: () => Navigator.pushNamed(context, '/savings/form'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
