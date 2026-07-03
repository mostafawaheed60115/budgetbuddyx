import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/expense_model.dart';
import '../../providers/expense_provider.dart';
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

class ExpenseFormScreen extends StatefulWidget {
  const ExpenseFormScreen({super.key});

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = _categories.first;
  DateTime _selectedDate = DateTime.now();
  bool _isRecurring = false;
  ExpenseModel? _existing;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is ExpenseModel) {
        _existing = args;
        _amountController.text = args.amount.toString();
        _descriptionController.text = args.description ?? '';
        _isRecurring = args.isRecurring;
        if (_categories.contains(args.category)) {
          _selectedCategory = args.category;
        }
        if (args.date != null) {
          _selectedDate = DateTime.tryParse(args.date!) ?? DateTime.now();
        }
      }
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<ExpenseProvider>();
    final expense = ExpenseModel(
      category: _selectedCategory,
      amount: double.tryParse(_amountController.text) ?? 0,
      date: _selectedDate.toIso8601String(),
      description: _descriptionController.text.trim(),
      isRecurring: _isRecurring,
    );

    bool success;
    if (_existing != null && _existing!.id != null) {
      success = await provider.update(_existing!.id!, expense);
    } else {
      success = await provider.create(expense);
    }

    if (success && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = _existing != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? AppStrings.editExpense : AppStrings.addExpense),
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
                controller: _amountController,
                label: AppStrings.amount,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (double.tryParse(v) == null) return 'Invalid number';
                  return null;
                },
              ),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: TextEditingController(
                      text: DateFormat('yyyy-MM-dd').format(_selectedDate),
                    ),
                    label: AppStrings.date,
                  ),
                ),
              ),
              CustomTextField(
                controller: _descriptionController,
                label: AppStrings.description,
                maxLines: 3,
              ),
              SwitchListTile(
                title: Text(AppStrings.isRecurring),
                value: _isRecurring,
                activeThumbColor: AppColors.primary,
                onChanged: (v) => setState(() => _isRecurring = v),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),
              Consumer<ExpenseProvider>(
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
