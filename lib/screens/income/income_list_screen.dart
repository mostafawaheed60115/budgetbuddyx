import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/income_provider.dart';
import '../widgets/empty_state.dart';

class IncomeListScreen extends StatefulWidget {
  const IncomeListScreen({super.key});

  @override
  State<IncomeListScreen> createState() => _IncomeListScreenState();
}

class _IncomeListScreenState extends State<IncomeListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<IncomeProvider>().fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.income)),
      body: Consumer<IncomeProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.incomes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.incomes.isEmpty) {
            return const EmptyState(
              icon: Icons.trending_up,
              message: 'No income records yet',
            );
          }
          return RefreshIndicator(
            onRefresh: provider.fetchAll,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.incomes.length,
              itemBuilder: (context, index) {
                final income = provider.incomes[index];
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const BehindMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Income'),
                              content: const Text('Are you sure?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text(AppStrings.cancel)),
                                TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text(AppStrings.delete, style: TextStyle(color: AppColors.danger))),
                              ],
                            ),
                          );
                          if (confirm == true && income.id != null) {
                            provider.delete(income.id!);
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
                    child: ListTile(
                      title: Text(
                        income.source,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: income.date != null
                          ? Text(
                              income.date!.substring(0, 10),
                              style: const TextStyle(color: AppColors.secondaryText, fontSize: 13),
                            )
                          : null,
                      trailing: Text(
                        currencyFormat.format(income.amount),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () => Navigator.pushNamed(context, '/income/form', arguments: income),
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
        onPressed: () => Navigator.pushNamed(context, '/income/form'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
