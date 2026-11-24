import 'package:flutter/material.dart';

import '../../domain/models/app_notification.dart';
import '../../domain/models/notification_filter.dart';
import '../services/in_memory_commune_service.dart';

/// Repository quản lý lọc theo thời gian, sắp xếp thứ tự và trạng thái đọc thông báo.
class NotificationRepository {
  NotificationRepository({required this._service});

  final InMemoryCommuneService _service;

  int get unreadCount =>
      _service.notifications.where((item) => !item.isRead).length;

  List<AppNotification> getNotifications({
    required NotificationTimeFilter filter,
    required NotificationSortOrder sortOrder,
    DateTimeRange? customRange,
    DateTime? referenceNow,
  }) {
    final now = referenceNow ?? DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    final filtered = _service.notifications.where((notification) {
      final createdAt = notification.createdAt;
      switch (filter) {
        case NotificationTimeFilter.all:
          return true;
        case NotificationTimeFilter.today:
          return createdAt.year == now.year &&
              createdAt.month == now.month &&
              createdAt.day == now.day;
        case NotificationTimeFilter.last7Days:
          final start = todayStart.subtract(const Duration(days: 6));
          return !createdAt.isBefore(start) && !createdAt.isAfter(todayEnd);
        case NotificationTimeFilter.last30Days:
          final start = todayStart.subtract(const Duration(days: 29));
          return !createdAt.isBefore(start) && !createdAt.isAfter(todayEnd);
        case NotificationTimeFilter.customRange:
          if (customRange == null) {
            return true;
          }
          final start = DateTime(
            customRange.start.year,
            customRange.start.month,
            customRange.start.day,
          );
          final end = DateTime(
            customRange.end.year,
            customRange.end.month,
            customRange.end.day,
            23,
            59,
            59,
            999,
          );
          return !createdAt.isBefore(start) && !createdAt.isAfter(end);
      }
    }).toList();

    filtered.sort((a, b) {
      return switch (sortOrder) {
        NotificationSortOrder.newestFirst => b.createdAt.compareTo(a.createdAt),
        NotificationSortOrder.oldestFirst => a.createdAt.compareTo(b.createdAt),
      };
    });

    return filtered;
  }

  void markAsRead(String id) {
    for (final item in _service.notifications) {
      if (item.id == id && !item.isRead) {
        _service.updateNotification(item.copyWith(isRead: true));
        break;
      }
    }
  }

  void markAllAsRead() {
    final updated = _service.notifications
        .map((item) => item.isRead ? item : item.copyWith(isRead: true))
        .toList();
    _service.replaceAllNotifications(updated);
  }
}
