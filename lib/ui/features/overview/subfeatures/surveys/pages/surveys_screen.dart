import 'package:flutter/material.dart';

import '../view_models/surveys_view_model.dart';
import '../widgets/survey_card.dart';

/// Màn hình Khảo sát ý kiến dân cư.
class SurveysScreen extends StatelessWidget {
  const SurveysScreen({
    super.key,
    required this.viewModel,
    required this.currentUserId,
  });

  final SurveysViewModel viewModel;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Khảo sát')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          final surveys = viewModel.surveys;
          if (surveys.isEmpty) {
            return const Center(child: Text('Hiện chưa có cuộc khảo sát nào.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: surveys.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final survey = surveys[index];
              return SurveyCard(
                survey: survey,
                currentUserId: currentUserId,
                onSelectOption: (optionId) {
                  final error = viewModel.vote(
                    surveyId: survey.id,
                    optionId: optionId,
                    userId: currentUserId,
                  );
                  if (error != null) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(error)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã ghi nhận lựa chọn khảo sát của bạn.'),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
