/// Một phương án lựa chọn trong khảo sát cộng đồng.
class SurveyOption {
  const SurveyOption({
    required this.id,
    required this.label,
    required this.voteCount,
  });

  final String id;
  final String label;
  final int voteCount;

  SurveyOption copyWith({String? id, String? label, int? voteCount}) {
    return SurveyOption(
      id: id ?? this.id,
      label: label ?? this.label,
      voteCount: voteCount ?? this.voteCount,
    );
  }
}

/// Khảo sát lấy ý kiến cư dân xã/thôn.
class Survey {
  const Survey({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.options,
    this.votedOptionIdByUser = const <String, String>{},
    this.isClosed = false,
  });

  final String id;
  final String title;
  final String description;
  final DateTime deadline;
  final List<SurveyOption> options;
  final Map<String, String> votedOptionIdByUser;
  final bool isClosed;

  int get totalVotes =>
      options.fold<int>(0, (sum, option) => sum + option.voteCount);

  String? votedOptionFor(String userId) => votedOptionIdByUser[userId];

  Survey copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? deadline,
    List<SurveyOption>? options,
    Map<String, String>? votedOptionIdByUser,
    bool? isClosed,
  }) {
    return Survey(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      options: options ?? this.options,
      votedOptionIdByUser: votedOptionIdByUser ?? this.votedOptionIdByUser,
      isClosed: isClosed ?? this.isClosed,
    );
  }
}
