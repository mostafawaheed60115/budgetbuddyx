import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../models/budget_model.dart';
import '../../providers/budget_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

const _categories = [
  'Food',
  'Transport',
  'Housing',
  'Entertainment',
  'Shopping',
  'Health',
  'Education',
  'Utilities',
  'Other',
];

class BudgetFormScreen extends StatefulWidget {
  const BudgetFormScreen({super.key});

  @override
  State<BudgetFormScreen> createState() => _BudgetFormScreenState();
}

class _BudgetFormScreenState extends State<BudgetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _limitController = TextEditingController();
  String _selectedCategory = _categories.first;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  BudgetModel? _existing;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is BudgetModel) {
        _existing = args;
        _limitController.text = args.budgetLimit.toString();
        if (_categories.contains(args.category)) {
          _selectedCategory = args.category;
        }
        _selectedMonth = args.month;
        _selectedYear = args.year;
      }
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<BudgetProvider>();
    final budget = BudgetModel(
      category: _selectedCategory,
      budgetLimit: double.tryParse(_limitController.text) ?? 0,
      month: _selectedMonth,
      year: _selectedYear,
    );

    bool success;
    if (_existing != null && _existing!.id != null) {
      success = await provider.update(_existing!.id!, budget);
    } else {
      success = await provider.create(budget);
    }

    if (success && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = _existing != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? AppStrings.editBudget : AppStrings.addBudget),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(labelText: AppStrings.category),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _limitController,
                label: AppStrings.budgetLimit,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (double.tryParse(v) == null) return 'Invalid number';
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                initialValue: _selectedMonth,
                decoration: InputDecoration(labelText: AppStrings.month),
                items: List.generate(12, (i) => i + 1)
                    .map((m) => DropdownMenuItem(value: m, child: Text('$m')))
                    .toList(),
                onChanged: (v) => setState(() => _selectedMonth = v!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: _selectedYear,
                decoration: InputDecoration(labelText: AppStrings.year),
                items: List.generate(6, (i) => DateTime.now().year - 1 + i)
                    .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
                    .toList(),
                onChanged: (v) => setState(() => _selectedYear = v!),
              ),
              const SizedBox(height: 24),
              Consumer<BudgetProvider>(
                builder: (context, provider, _) {
                  return CustomButton(
                    text: AppStrings.save,
                    isLoading: provider.isLoading,
                    onPressed: _save,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
