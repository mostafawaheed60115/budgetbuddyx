import '../core/network/api_client.dart';
import '../core/constants/api_endpoints.dart';
import '../models/user_model.dart';

class AuthService {
  final ApiClient _client;

  AuthService(this._client);

  Future<UserModel> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await _client.post(ApiEndpoints.signup, {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'confirmPassword': confirmPassword,
    });
    return UserModel.fromJson(response['user'] ?? response);
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(ApiEndpoints.login, {
      'email': email,
      'password': password,
    });
    return UserModel.fromJson(response['user'] ?? response);
  }
}
