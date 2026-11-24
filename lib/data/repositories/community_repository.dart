import '../../domain/models/citizen_feedback.dart';
import '../../domain/models/meeting_schedule.dart';
import '../../domain/models/news_article.dart';
import '../../domain/models/survey.dart';
import '../../domain/models/user_role.dart';
import '../services/in_memory_commune_service.dart';

/// Repository quản lý Tin tức, Khảo sát, Ý kiến và Lịch họp cộng đồng.
class CommunityRepository {
  CommunityRepository({required this._service});

  final InMemoryCommuneService _service;

  List<NewsArticle> getNews() {
    final items = List<NewsArticle>.of(_service.news);
    items.sort((a, b) {
      if (a.isPinned != b.isPinned) {
        return a.isPinned ? -1 : 1;
      }
      return b.publishedAt.compareTo(a.publishedAt);
    });
    return items;
  }

  List<Survey> getSurveys() => List<Survey>.of(_service.surveys);

  void voteSurvey({
    required String surveyId,
    required String optionId,
    required String userId,
  }) {
    final survey = _service.surveys.firstWhere((item) => item.id == surveyId);
    if (survey.isClosed) {
      throw StateError('Khảo sát này đã kết thúc bình chọn.');
    }

    final previousOptionId = survey.votedOptionFor(userId);
    if (previousOptionId == optionId) {
      return;
    }

    final updatedOptions = survey.options.map((option) {
      var votes = option.voteCount;
      if (option.id == previousOptionId && votes > 0) {
        votes -= 1;
      }
      if (option.id == optionId) {
        votes += 1;
      }
      return option.copyWith(voteCount: votes);
    }).toList();

    final updatedVotesByUser = Map<String, String>.of(
      survey.votedOptionIdByUser,
    )..[userId] = optionId;

    _service.updateSurvey(
      survey.copyWith(
        options: updatedOptions,
        votedOptionIdByUser: updatedVotesByUser,
      ),
    );
  }

  List<CitizenFeedback> getFeedbacks() {
    final items = List<CitizenFeedback>.of(_service.feedbacks);
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  void addFeedback({
    required String title,
    required String content,
    required String category,
    required String authorId,
    required String authorName,
  }) {
    _service.addFeedback(
      CitizenFeedback(
        id: 'fb-${DateTime.now().microsecondsSinceEpoch}',
        title: title.trim(),
        content: content.trim(),
        category: category,
        authorId: authorId,
        authorName: authorName,
        createdAt: DateTime.now(),
        status: FeedbackStatus.pending,
      ),
    );
  }

  void replyFeedback({
    required UserRole actorRole,
    required String feedbackId,
    required FeedbackStatus status,
    required String reply,
  }) {
    if (!actorRole.canManageResidents) {
      throw StateError(
        'Chỉ Admin hoặc Trưởng thôn mới có quyền phản hồi ý kiến.',
      );
    }
    final existing = _service.feedbacks.firstWhere(
      (item) => item.id == feedbackId,
    );
    _service.updateFeedback(
      existing.copyWith(
        status: status,
        officialReply: reply.trim().isEmpty ? null : reply.trim(),
      ),
    );
  }

  List<MeetingSchedule> getMeetings() {
    final items = List<MeetingSchedule>.of(_service.meetings);
    items.sort((a, b) => b.startTime.compareTo(a.startTime));
    return items;
  }

  void toggleMeetingRsvp({required String meetingId, required String userId}) {
    final meeting = _service.meetings.firstWhere(
      (item) => item.id == meetingId,
    );
    final updatedIds = List<String>.of(meeting.confirmedUserIds);
    if (updatedIds.contains(userId)) {
      updatedIds.remove(userId);
    } else {
      updatedIds.add(userId);
    }
    _service.updateMeeting(meeting.copyWith(confirmedUserIds: updatedIds));
  }
}
