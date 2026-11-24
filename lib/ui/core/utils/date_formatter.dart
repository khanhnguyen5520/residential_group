/// Tiện ích định dạng ngày giờ tiếng Việt thống nhất trong ứng dụng.
abstract final class DateFormatter {
  static String _twoDigits(int value) => value.toString().padLeft(2, '0');

  static String formatDate(DateTime dateTime) {
    return '${_twoDigits(dateTime.day)}/${_twoDigits(dateTime.month)}/${dateTime.year}';
  }

  static String formatTime(DateTime dateTime) {
    return '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}';
  }

  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)} • ${formatTime(dateTime)}';
  }

  static String formatRelative(DateTime dateTime, {DateTime? now}) {
    final anchor = now ?? DateTime.now();
    final diff = anchor.difference(dateTime);
    if (diff.isNegative) {
      return formatDateTime(dateTime);
    }
    if (diff.inMinutes < 1) {
      return 'Vừa xong';
    }
    if (diff.inHours < 1) {
      return '${diff.inMinutes} phút trước';
    }
    if (diff.inDays == 0 && anchor.day == dateTime.day) {
      return '${diff.inHours} giờ trước';
    }
    final yesterday = DateTime(
      anchor.year,
      anchor.month,
      anchor.day,
    ).subtract(const Duration(days: 1));
    if (dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day) {
      return 'Hôm qua • ${formatTime(dateTime)}';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays} ngày trước';
    }
    return formatDate(dateTime);
  }
}
