import 'package:flutter/foundation.dart';
import 'package:residential_group/data/repositories/community_repository.dart';
import 'package:residential_group/domain/models/news_article.dart';

/// ViewModel cho chức năng Tin tức xã/thôn.
class NewsViewModel extends ChangeNotifier {
  NewsViewModel({required this._communityRepository}) {
    load();
  }

  final CommunityRepository _communityRepository;

  List<NewsArticle> _allArticles = const <NewsArticle>[];
  String _selectedCategory = 'Tất cả';

  String get selectedCategory => _selectedCategory;

  List<String> get categories {
    final set = <String>{'Tất cả'};
    for (final article in _allArticles) {
      set.add(article.category);
    }
    return set.toList();
  }

  List<NewsArticle> get articles {
    if (_selectedCategory == 'Tất cả') {
      return _allArticles;
    }
    return _allArticles
        .where((article) => article.category == _selectedCategory)
        .toList();
  }

  void load() {
    _allArticles = _communityRepository.getNews();
    notifyListeners();
  }

  void selectCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }
}
