import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_strings.dart';
import '../../models/income_model.dart';
import '../../providers/income_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class IncomeFormScreen extends StatefulWidget {
  const IncomeFormScreen({super.key});

  @override
  State<IncomeFormScreen> createState() => _IncomeFormScreenState();
}

class _IncomeFormScreenState extends State<IncomeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sourceController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  IncomeModel? _existing;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is IncomeModel) {
        _existing = args;
        _sourceController.text = args.source;
        _amountController.text = args.amount.toString();
        _descriptionController.text = args.description ?? '';
        if (args.date != null) {
          _selectedDate = DateTime.tryParse(args.date!) ?? DateTime.now();
        }
      }
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _sourceController.dispose();
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
    final provider = context.read<IncomeProvider>();
    final income = IncomeModel(
      source: _sourceController.text.trim(),
      amount: double.tryParse(_amountController.text) ?? 0,
      date: _selectedDate.toIso8601String(),
      description: _descriptionController.text.trim(),
    );

    bool success;
    if (_existing != null && _existing!.id != null) {
      success = await provider.update(_existing!.id!, income);
    } else {
      success = await provider.create(income);
    }

    if (success && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = _existing != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? AppStrings.editIncome : AppStrings.addIncome),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _sourceController,
                label: AppStrings.source,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
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
              const SizedBox(height: 16),
              Consumer<IncomeProvider>(
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
