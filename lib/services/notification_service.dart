import '../core/network/api_client.dart';
import '../core/constants/api_endpoints.dart';
import '../models/notification_model.dart';

class NotificationService {
  final ApiClient _client;

  NotificationService(this._client);

  Future<List<NotificationModel>> getAll() async {
    final response = await _client.get(ApiEndpoints.notifications);
    final list = response['data'] ?? response['notifications'] ?? [];
    return (list as List).map((e) => NotificationModel.fromJson(e)).toList();
  }

  Future<void> markAsRead(String id) async {
    await _client.put(ApiEndpoints.notificationRead(id));
  }

  Future<void> markAllAsRead() async {
    await _client.put(ApiEndpoints.notificationsReadAll);
  }
}
