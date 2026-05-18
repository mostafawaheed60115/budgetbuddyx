import 'package:flutter/material.dart';
import '../models/income_model.dart';
import '../services/income_service.dart';

class IncomeProvider extends ChangeNotifier {
  final IncomeService _service;

  List<IncomeModel> _incomes = [];
  bool _isLoading = false;
  String? _error;

  IncomeProvider(this._service);

  List<IncomeModel> get incomes => _incomes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get totalIncome => _incomes.fold(0, (sum, e) => sum + e.amount);

  Future<void> fetchAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _incomes = await _service.getAll();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> create(IncomeModel income) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.create(income);
      await fetchAll();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> update(String id, IncomeModel income) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.update(id, income);
      await fetchAll();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _service.delete(id);
      _incomes.removeWhere((e) => e.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
