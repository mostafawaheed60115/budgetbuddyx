import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/notification_provider.dart';
import '../../models/notification_model.dart';
import '../widgets/empty_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _showUnreadOnly = false;

  @override
  void initState() {
    super.initState();
    context.read<NotificationProvider>().fetchAll();
  }

  IconData _getIcon(String? type) {
    switch (type) {
      case 'budget_exceeded':
      case 'budget_warning':
        return Icons.warning_amber;
      case 'savings_goal':
        return Icons.savings;
      case 'expense':
        return Icons.trending_down;
      case 'income':
        return Icons.trending_up;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor(String? type) {
    switch (type) {
      case 'budget_exceeded':
        return AppColors.danger;
      case 'budget_warning':
        return Colors.orange;
      case 'savings_goal':
        return AppColors.primary;
      default:
        return AppColors.secondaryText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.notifications),
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, provider, _) {
              if (provider.unreadCount > 0) {
                return TextButton(
                  onPressed: provider.markAllAsRead,
                  child: const Text(AppStrings.markAllAsRead),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _FilterChip(
                  label: AppStrings.all,
                  selected: !_showUnreadOnly,
                  onTap: () => setState(() => _showUnreadOnly = false),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: AppStrings.unread,
                  selected: _showUnreadOnly,
                  onTap: () => setState(() => _showUnreadOnly = true),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<NotificationProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading && provider.notifications.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final list = _showUnreadOnly
                    ? provider.unreadNotifications
                    : provider.notifications;

                if (list.isEmpty) {
                  return const EmptyState(
                    icon: Icons.notifications_none,
                    message: 'No notifications',
                  );
                }

                return RefreshIndicator(
                  onRefresh: provider.fetchAll,
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final notif = list[index];
                      return _NotificationTile(
                        notification: notif,
                        icon: _getIcon(notif.notificationType),
                        iconColor: _getIconColor(notif.notificationType),
                        onTap: () {
                          if (!notif.isRead && notif.id != null) {
                            provider.markAsRead(notif.id!);
                          }
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.secondaryBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.white : AppColors.secondaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: notification.isRead ? null : AppColors.primary.withAlpha(12),
      leading: CircleAvatar(
        backgroundColor: iconColor.withAlpha(25),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        notification.message,
        style: TextStyle(
          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w600,
          fontSize: 14,
        ),
      ),
      subtitle: notification.createdAt != null
          ? Text(
              notification.createdAt!.substring(0, 10),
              style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
            )
          : null,
      trailing: notification.isRead
          ? null
          : const CircleAvatar(
              radius: 5,
              backgroundColor: AppColors.primary,
            ),
    );
  }
}
