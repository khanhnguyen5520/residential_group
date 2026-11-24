import 'package:flutter/foundation.dart';
import 'package:residential_group/data/repositories/community_repository.dart';
import 'package:residential_group/domain/models/meeting_schedule.dart';

/// ViewModel cho chức năng Lịch họp dân cư xã/thôn.
class MeetingsViewModel extends ChangeNotifier {
  MeetingsViewModel({required this._communityRepository}) {
    load();
  }

  final CommunityRepository _communityRepository;
  List<MeetingSchedule> _meetings = const <MeetingSchedule>[];

  List<MeetingSchedule> get meetings => _meetings;

  void load() {
    _meetings = _communityRepository.getMeetings();
    notifyListeners();
  }

  void toggleRsvp({required String meetingId, required String userId}) {
    _communityRepository.toggleMeetingRsvp(
      meetingId: meetingId,
      userId: userId,
    );
    load();
  }
}
