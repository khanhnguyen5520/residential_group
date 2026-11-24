import 'package:flutter/material.dart';
import 'package:residential_group/domain/models/survey.dart';
import 'package:residential_group/ui/core/utils/date_formatter.dart';

import '../view_models/surveys_view_model.dart';

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
              return _SurveyCard(
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

class _SurveyCard extends StatelessWidget {
  const _SurveyCard({
    required this.survey,
    required this.currentUserId,
    required this.onSelectOption,
  });

  final Survey survey;
  final String currentUserId;
  final ValueChanged<String> onSelectOption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedOptionId = survey.votedOptionFor(currentUserId);
    final totalVotes = survey.totalVotes;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        (survey.isClosed
                                ? theme.colorScheme.outline
                                : theme.colorScheme.primary)
                            .withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    survey.isClosed ? 'Đã kết thúc' : 'Đang mở bình chọn',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: survey.isClosed
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.colorScheme.primary,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Hạn: ${DateFormatter.formatDate(survey.deadline)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              survey.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              survey.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            ...survey.options.map((option) {
              final isSelected = option.id == selectedOptionId;
              final ratio = totalVotes == 0
                  ? 0.0
                  : option.voteCount / totalVotes;
              final percent = (ratio * 100).round();

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: survey.isClosed
                      ? null
                      : () => onSelectOption(option.id),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outlineVariant,
                        width: isSelected ? 1.6 : 1,
                      ),
                      color: isSelected
                          ? theme.colorScheme.primary.withValues(alpha: 0.06)
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              size: 20,
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                option.label,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$percent%',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: ratio,
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${option.voteCount} lượt chọn',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 4),
            Text(
              'Tổng cộng: $totalVotes lượt bình chọn',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
