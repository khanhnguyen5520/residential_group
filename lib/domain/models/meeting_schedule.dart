/// Lịch họp dân cư, họp thôn và họp giao ban xã.
class MeetingSchedule {
  const MeetingSchedule({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.hostName,
    required this.scope,
    this.confirmedUserIds = const <String>[],
  });

  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String hostName;
  final String scope;
  final List<String> confirmedUserIds;

  bool isConfirmedBy(String userId) => confirmedUserIds.contains(userId);

  MeetingSchedule copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? hostName,
    String? scope,
    List<String>? confirmedUserIds,
  }) {
    return MeetingSchedule(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      hostName: hostName ?? this.hostName,
      scope: scope ?? this.scope,
      confirmedUserIds: confirmedUserIds ?? this.confirmedUserIds,
    );
  }
}
