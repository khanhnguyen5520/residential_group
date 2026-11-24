import 'package:flutter/foundation.dart';
import 'package:residential_group/data/repositories/community_repository.dart';
import 'package:residential_group/domain/models/survey.dart';

/// ViewModel cho chức năng Khảo sát cộng đồng.
class SurveysViewModel extends ChangeNotifier {
  SurveysViewModel({required this._communityRepository}) {
    load();
  }

  final CommunityRepository _communityRepository;
  List<Survey> _surveys = const <Survey>[];

  List<Survey> get surveys => _surveys;

  void load() {
    _surveys = _communityRepository.getSurveys();
    notifyListeners();
  }

  String? vote({
    required String surveyId,
    required String optionId,
    required String userId,
  }) {
    try {
      _communityRepository.voteSurvey(
        surveyId: surveyId,
        optionId: optionId,
        userId: userId,
      );
      load();
      return null;
    } on Object catch (error) {
      return error is StateError ? error.message : error.toString();
    }
  }
}
