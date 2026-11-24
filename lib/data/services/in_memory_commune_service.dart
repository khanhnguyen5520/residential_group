import '../../domain/models/app_notification.dart';
import '../../domain/models/citizen_feedback.dart';
import '../../domain/models/meeting_schedule.dart';
import '../../domain/models/news_article.dart';
import '../../domain/models/resident_account.dart';
import '../../domain/models/survey.dart';
import 'seed_data.dart';

/// Dịch vụ lưu trữ dữ liệu trong bộ nhớ đóng vai trò nguồn dữ liệu thống nhất cho toàn ứng dụng.
class InMemoryCommuneService {
  InMemoryCommuneService({this._seedReferenceTime}) {
    resetDemoData();
  }

  final DateTime? _seedReferenceTime;

  late List<ResidentAccount> _residents;
  late List<AppNotification> _notifications;
  late List<NewsArticle> _news;
  late List<Survey> _surveys;
  late List<CitizenFeedback> _feedbacks;
  late List<MeetingSchedule> _meetings;
  String? _currentUserId;

  String? get currentUserId => _currentUserId;

  ResidentAccount? get currentUser {
    final id = _currentUserId;
    if (id == null) {
      return null;
    }
    for (final resident in _residents) {
      if (resident.id == id) {
        return resident;
      }
    }
    return null;
  }

  List<ResidentAccount> get residents =>
      List<ResidentAccount>.unmodifiable(_residents);
  List<AppNotification> get notifications =>
      List<AppNotification>.unmodifiable(_notifications);
  List<NewsArticle> get news => List<NewsArticle>.unmodifiable(_news);
  List<Survey> get surveys => List<Survey>.unmodifiable(_surveys);
  List<CitizenFeedback> get feedbacks =>
      List<CitizenFeedback>.unmodifiable(_feedbacks);
  List<MeetingSchedule> get meetings =>
      List<MeetingSchedule>.unmodifiable(_meetings);

  void setCurrentUserId(String? id) {
    _currentUserId = id;
  }

  void resetDemoData() {
    _residents = SeedData.createResidents();
    _notifications = SeedData.createNotifications(now: _seedReferenceTime);
    _news = SeedData.createNews(now: _seedReferenceTime);
    _surveys = SeedData.createSurveys(now: _seedReferenceTime);
    _feedbacks = SeedData.createFeedbacks(now: _seedReferenceTime);
    _meetings = SeedData.createMeetings(now: _seedReferenceTime);
    _currentUserId = null;
  }

  void addResident(ResidentAccount resident) {
    _residents = <ResidentAccount>[resident, ..._residents];
  }

  void updateResident(ResidentAccount updated) {
    _residents = _residents
        .map((item) => item.id == updated.id ? updated : item)
        .toList();
  }

  void removeResident(String id) {
    _residents = _residents.where((item) => item.id != id).toList();
    if (_currentUserId == id) {
      _currentUserId = null;
    }
  }

  void updateNotification(AppNotification updated) {
    _notifications = _notifications
        .map((item) => item.id == updated.id ? updated : item)
        .toList();
  }

  void replaceAllNotifications(List<AppNotification> items) {
    _notifications = List<AppNotification>.of(items);
  }

  void addNotification(AppNotification notification) {
    _notifications = <AppNotification>[notification, ..._notifications];
  }

  void updateSurvey(Survey updated) {
    _surveys = _surveys
        .map((item) => item.id == updated.id ? updated : item)
        .toList();
  }

  void addFeedback(CitizenFeedback feedback) {
    _feedbacks = <CitizenFeedback>[feedback, ..._feedbacks];
  }

  void updateFeedback(CitizenFeedback updated) {
    _feedbacks = _feedbacks
        .map((item) => item.id == updated.id ? updated : item)
        .toList();
  }

  void updateMeeting(MeetingSchedule updated) {
    _meetings = _meetings
        .map((item) => item.id == updated.id ? updated : item)
        .toList();
  }
}
