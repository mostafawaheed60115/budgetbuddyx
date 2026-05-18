import '../core/network/api_client.dart';
import '../core/constants/api_endpoints.dart';
import '../models/income_model.dart';

class IncomeService {
  final ApiClient _client;

  IncomeService(this._client);

  Future<List<IncomeModel>> getAll() async {
    final response = await _client.get(ApiEndpoints.income);
    final list = response['data'] ?? response['incomes'] ?? [];
    return (list as List).map((e) => IncomeModel.fromJson(e)).toList();
  }

  Future<IncomeModel> getById(String id) async {
    final response = await _client.get(ApiEndpoints.incomeById(id));
    return IncomeModel.fromJson(response['income'] ?? response);
  }

  Future<IncomeModel> create(IncomeModel income) async {
    final response = await _client.post(ApiEndpoints.income, income.toJson());
    return IncomeModel.fromJson(response['income'] ?? response);
  }

  Future<IncomeModel> update(String id, IncomeModel income) async {
    final response = await _client.patch(ApiEndpoints.incomeById(id), income.toJson());
    return IncomeModel.fromJson(response['income'] ?? response);
  }

  Future<void> delete(String id) async {
    await _client.delete(ApiEndpoints.incomeById(id));
  }
}
