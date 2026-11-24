import 'package:flutter/material.dart';
import 'package:residential_group/domain/models/news_article.dart';
import 'package:residential_group/ui/core/utils/date_formatter.dart';

import '../view_models/news_view_model.dart';
import '../widgets/news_card.dart';

/// Màn hình Tin tức xã/thôn với bộ lọc chuyên mục và chi tiết bài viết.
class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key, required this.viewModel});

  final NewsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tin tức')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          final categories = viewModel.categories;
          final articles = viewModel.articles;

          return Column(
            children: [
              SizedBox(
                height: 52,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return ChoiceChip(
                      label: Text(category),
                      selected: viewModel.selectedCategory == category,
                      onSelected: (_) => viewModel.selectCategory(category),
                    );
                  },
                ),
              ),
              Expanded(
                child: articles.isEmpty
                    ? const Center(
                        child: Text('Chưa có tin tức trong mục này.'),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: articles.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final article = articles[index];
                          return NewsCard(
                            article: article,
                            onTap: () => _openArticleDetail(context, article),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openArticleDetail(BuildContext context, NewsArticle article) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        final theme = Theme.of(context);
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.78,
          minChildSize: 0.45,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
              children: [
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Chip(
                      label: Text(article.category),
                      visualDensity: VisualDensity.compact,
                    ),
                    if (article.isPinned)
                      const Chip(
                        avatar: Icon(Icons.push_pin_outlined, size: 16),
                        label: Text('Tin nổi bật'),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  article.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${article.authorName} • ${DateFormatter.formatDateTime(article.publishedAt)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Divider(height: 24),
                Text(
                  article.summary,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  article.content,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
