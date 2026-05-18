import 'package:flutter/material.dart';
import '../models/savings_model.dart';
import '../services/savings_service.dart';

class SavingsProvider extends ChangeNotifier {
  final SavingsService _service;

  List<SavingsModel> _savings = [];
  bool _isLoading = false;
  String? _error;

  SavingsProvider(this._service);

  List<SavingsModel> get savings => _savings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _savings = await _service.getAll();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> create(SavingsModel savings) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.create(savings);
      await fetchAll();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> update(String id, SavingsModel savings) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.update(id, savings);
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
      _savings.removeWhere((e) => e.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
