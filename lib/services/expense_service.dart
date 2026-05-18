import '../core/network/api_client.dart';
import '../core/constants/api_endpoints.dart';
import '../models/expense_model.dart';

class ExpenseService {
  final ApiClient _client;

  ExpenseService(this._client);

  Future<List<ExpenseModel>> getAll() async {
    final response = await _client.get(ApiEndpoints.expenses);
    final list = response['data'] ?? response['expenses'] ?? [];
    return (list as List).map((e) => ExpenseModel.fromJson(e)).toList();
  }

  Future<ExpenseModel> getById(String id) async {
    final response = await _client.get(ApiEndpoints.expenseById(id));
    return ExpenseModel.fromJson(response['expense'] ?? response);
  }

  Future<ExpenseModel> create(ExpenseModel expense) async {
    final response = await _client.post(ApiEndpoints.expenses, expense.toJson());
    return ExpenseModel.fromJson(response['expense'] ?? response);
  }

  Future<ExpenseModel> update(String id, ExpenseModel expense) async {
    final response = await _client.patch(ApiEndpoints.expenseById(id), expense.toJson());
    return ExpenseModel.fromJson(response['expense'] ?? response);
  }

  Future<void> delete(String id) async {
    await _client.delete(ApiEndpoints.expenseById(id));
  }
}
