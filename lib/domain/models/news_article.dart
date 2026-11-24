/// Bản tin thông tin của UBND xã và các thôn.
class NewsArticle {
  const NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.category,
    required this.authorName,
    required this.publishedAt,
    this.isPinned = false,
  });

  final String id;
  final String title;
  final String summary;
  final String content;
  final String category;
  final String authorName;
  final DateTime publishedAt;
  final bool isPinned;

  NewsArticle copyWith({
    String? id,
    String? title,
    String? summary,
    String? content,
    String? category,
    String? authorName,
    DateTime? publishedAt,
    bool? isPinned,
  }) {
    return NewsArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      category: category ?? this.category,
      authorName: authorName ?? this.authorName,
      publishedAt: publishedAt ?? this.publishedAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}
