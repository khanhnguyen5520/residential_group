import 'package:flutter/material.dart';

import '../../../../data/repositories/notification_repository.dart';
import '../../../../domain/models/app_notification.dart';
import '../../../../domain/models/notification_filter.dart';

/// ViewModel quản lý lọc thời gian, sắp xếp và trạng thái đọc thông báo.
class NotificationsViewModel extends ChangeNotifier {
  NotificationsViewModel({required this._notificationRepository}) {
    refresh();
  }

  final NotificationRepository _notificationRepository;

  NotificationTimeFilter _timeFilter = NotificationTimeFilter.all;
  NotificationSortOrder _sortOrder = NotificationSortOrder.newestFirst;
  DateTimeRange? _customRange;
  List<AppNotification> _notifications = const <AppNotification>[];

  NotificationTimeFilter get timeFilter => _timeFilter;
  NotificationSortOrder get sortOrder => _sortOrder;
  DateTimeRange? get customRange => _customRange;
  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _notificationRepository.unreadCount;

  void refresh() {
    _notifications = _notificationRepository.getNotifications(
      filter: _timeFilter,
      sortOrder: _sortOrder,
      customRange: _customRange,
    );
    notifyListeners();
  }

  void setTimeFilter(NotificationTimeFilter filter) {
    _timeFilter = filter;
    refresh();
  }

  void setCustomRange(DateTimeRange range) {
    _customRange = range;
    _timeFilter = NotificationTimeFilter.customRange;
    refresh();
  }

  void setSortOrder(NotificationSortOrder order) {
    _sortOrder = order;
    refresh();
  }

  void markAsRead(String id) {
    _notificationRepository.markAsRead(id);
    refresh();
  }

  void markAllAsRead() {
    _notificationRepository.markAllAsRead();
    refresh();
  }
}
