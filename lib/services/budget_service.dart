import '../core/network/api_client.dart';
import '../core/constants/api_endpoints.dart';
import '../models/budget_model.dart';

class BudgetService {
  final ApiClient _client;

  BudgetService(this._client);

  Future<List<BudgetModel>> getAll() async {
    final response = await _client.get(ApiEndpoints.budgets);
    final list = response['data'] ?? response['budgets'] ?? [];
    return (list as List).map((e) => BudgetModel.fromJson(e)).toList();
  }

  Future<BudgetModel> getById(String id) async {
    final response = await _client.get(ApiEndpoints.budgetById(id));
    return BudgetModel.fromJson(response['budget'] ?? response);
  }

  Future<BudgetModel> create(BudgetModel budget) async {
    final response = await _client.post(ApiEndpoints.budgets, budget.toJson());
    return BudgetModel.fromJson(response['budget'] ?? response);
  }

  Future<BudgetModel> update(String id, BudgetModel budget) async {
    final response = await _client.patch(ApiEndpoints.budgetById(id), budget.toJson());
    return BudgetModel.fromJson(response['budget'] ?? response);
  }

  Future<void> delete(String id) async {
    await _client.delete(ApiEndpoints.budgetById(id));
  }
}
