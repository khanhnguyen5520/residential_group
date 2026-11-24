import 'package:flutter/foundation.dart';
import 'package:residential_group/data/repositories/community_repository.dart';
import 'package:residential_group/domain/models/citizen_feedback.dart';
import 'package:residential_group/domain/models/user_role.dart';

/// ViewModel cho chức năng Ý kiến & kiến nghị cư dân.
class FeedbackViewModel extends ChangeNotifier {
  FeedbackViewModel({required this._communityRepository}) {
    load();
  }

  final CommunityRepository _communityRepository;
  List<CitizenFeedback> _feedbacks = const <CitizenFeedback>[];

  List<CitizenFeedback> get feedbacks => _feedbacks;

  void load() {
    _feedbacks = _communityRepository.getFeedbacks();
    notifyListeners();
  }

  void submitFeedback({
    required String title,
    required String content,
    required String category,
    required String authorId,
    required String authorName,
  }) {
    _communityRepository.addFeedback(
      title: title,
      content: content,
      category: category,
      authorId: authorId,
      authorName: authorName,
    );
    load();
  }

  String? replyFeedback({
    required UserRole actorRole,
    required String feedbackId,
    required FeedbackStatus status,
    required String reply,
  }) {
    try {
      _communityRepository.replyFeedback(
        actorRole: actorRole,
        feedbackId: feedbackId,
        status: status,
        reply: reply,
      );
      load();
      return null;
    } on Object catch (error) {
      return error is StateError ? error.message : error.toString();
    }
  }
}
