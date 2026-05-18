import '../core/network/api_client.dart';
import '../core/constants/api_endpoints.dart';
import '../models/savings_model.dart';

class SavingsService {
  final ApiClient _client;

  SavingsService(this._client);

  Future<List<SavingsModel>> getAll() async {
    final response = await _client.get(ApiEndpoints.savings);
    final list = response['data'] ?? response['savings'] ?? [];
    return (list as List).map((e) => SavingsModel.fromJson(e)).toList();
  }

  Future<SavingsModel> getById(String id) async {
    final response = await _client.get(ApiEndpoints.savingsById(id));
    return SavingsModel.fromJson(response['saving'] ?? response['savings'] ?? response);
  }

  Future<SavingsModel> create(SavingsModel savings) async {
    final response = await _client.post(ApiEndpoints.savings, savings.toJson());
    return SavingsModel.fromJson(response['saving'] ?? response['savings'] ?? response);
  }

  Future<SavingsModel> update(String id, SavingsModel savings) async {
    final response = await _client.patch(ApiEndpoints.savingsById(id), savings.toJson());
    return SavingsModel.fromJson(response['saving'] ?? response['savings'] ?? response);
  }

  Future<void> delete(String id) async {
    await _client.delete(ApiEndpoints.savingsById(id));
  }
}
