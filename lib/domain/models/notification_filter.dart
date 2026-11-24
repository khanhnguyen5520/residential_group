/// Bộ lọc mốc thời gian cho danh sách thông báo.
enum NotificationTimeFilter {
  all,
  today,
  last7Days,
  last30Days,
  customRange;

  String get displayName => switch (this) {
    NotificationTimeFilter.all => 'Tất cả',
    NotificationTimeFilter.today => 'Hôm nay',
    NotificationTimeFilter.last7Days => '7 ngày qua',
    NotificationTimeFilter.last30Days => '30 ngày qua',
    NotificationTimeFilter.customRange => 'Tuỳ chọn',
  };
}

/// Thứ tự sắp xếp danh sách thông báo.
enum NotificationSortOrder {
  newestFirst,
  oldestFirst;

  String get displayName => switch (this) {
    NotificationSortOrder.newestFirst => 'Mới nhất',
    NotificationSortOrder.oldestFirst => 'Cũ nhất',
  };
}
