import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_strings.dart';
import '../../models/savings_model.dart';
import '../../providers/savings_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class SavingsFormScreen extends StatefulWidget {
  const SavingsFormScreen({super.key});

  @override
  State<SavingsFormScreen> createState() => _SavingsFormScreenState();
}

class _SavingsFormScreenState extends State<SavingsFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _goalNameController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _currentAmountController = TextEditingController();
  DateTime? _targetDate;
  SavingsModel? _existing;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is SavingsModel) {
        _existing = args;
        _goalNameController.text = args.goalName;
        _targetAmountController.text = args.targetAmount.toString();
        _currentAmountController.text = args.currentAmount.toString();
        if (args.targetDate != null) {
          _targetDate = DateTime.tryParse(args.targetDate!);
        }
      }
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _goalNameController.dispose();
    _targetAmountController.dispose();
    _currentAmountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? DateTime.now().add(const Duration(days: 90)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );
    if (picked != null) setState(() => _targetDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<SavingsProvider>();
    final savings = SavingsModel(
      goalName: _goalNameController.text.trim(),
      targetAmount: double.tryParse(_targetAmountController.text) ?? 0,
      currentAmount: double.tryParse(_currentAmountController.text) ?? 0,
      targetDate: _targetDate?.toIso8601String(),
    );

    bool success;
    if (_existing != null && _existing!.id != null) {
      success = await provider.update(_existing!.id!, savings);
    } else {
      success = await provider.create(savings);
    }

    if (success && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = _existing != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? AppStrings.editSavings : AppStrings.addSavings),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _goalNameController,
                label: AppStrings.goalName,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              CustomTextField(
                controller: _targetAmountController,
                label: AppStrings.targetAmount,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (double.tryParse(v) == null) return 'Invalid number';
                  return null;
                },
              ),
              CustomTextField(
                controller: _currentAmountController,
                label: AppStrings.currentAmount,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v != null && v.isNotEmpty && double.tryParse(v) == null) {
                    return 'Invalid number';
                  }
                  return null;
                },
              ),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: TextEditingController(
                      text: _targetDate != null
                          ? DateFormat('yyyy-MM-dd').format(_targetDate!)
                          : 'Select target date',
                    ),
                    label: AppStrings.targetDate,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Consumer<SavingsProvider>(
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
