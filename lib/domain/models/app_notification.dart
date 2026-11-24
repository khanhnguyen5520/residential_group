/// Phân loại nội dung thông báo của xã/thôn.
enum NotificationCategory {
  general,
  news,
  survey,
  meeting,
  resident;

  String get displayName => switch (this) {
    NotificationCategory.general => 'Chung',
    NotificationCategory.news => 'Tin tức',
    NotificationCategory.survey => 'Khảo sát',
    NotificationCategory.meeting => 'Lịch họp',
    NotificationCategory.resident => 'Dân cư',
  };
}

/// Thông báo gửi tới người dùng trong xã.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.createdAt,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String body;
  final NotificationCategory category;
  final DateTime createdAt;
  final bool isRead;

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    NotificationCategory? category,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
