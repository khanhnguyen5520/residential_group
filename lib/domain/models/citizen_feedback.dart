/// Trạng thái xử lý phản ánh/ý kiến của cư dân.
enum FeedbackStatus {
  pending,
  inProgress,
  resolved;

  String get displayName => switch (this) {
    FeedbackStatus.pending => 'Chờ tiếp nhận',
    FeedbackStatus.inProgress => 'Đang xử lý',
    FeedbackStatus.resolved => 'Đã giải quyết',
  };
}

/// Ý kiến, kiến nghị cư dân gửi tới ban quản lý xã/thôn.
class CitizenFeedback {
  const CitizenFeedback({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    required this.status,
    this.officialReply,
  });

  final String id;
  final String title;
  final String content;
  final String category;
  final String authorId;
  final String authorName;
  final DateTime createdAt;
  final FeedbackStatus status;
  final String? officialReply;

  CitizenFeedback copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    String? authorId,
    String? authorName,
    DateTime? createdAt,
    FeedbackStatus? status,
    String? officialReply,
  }) {
    return CitizenFeedback(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      officialReply: officialReply ?? this.officialReply,
    );
  }
}
