import 'package:flutter/material.dart';
import 'package:residential_group/domain/models/citizen_feedback.dart';
import 'package:residential_group/ui/core/utils/date_formatter.dart';

/// Thẻ hiển thị một ý kiến/kiến nghị của cư dân và phản hồi từ Ban quản lý.
class FeedbackCard extends StatelessWidget {
  const FeedbackCard({
    super.key,
    required this.feedback,
    required this.canReply,
    required this.onReplyTap,
  });

  final CitizenFeedback feedback;
  final bool canReply;
  final VoidCallback onReplyTap;

  Color _statusColor(FeedbackStatus status) => switch (status) {
    FeedbackStatus.pending => const Color(0xFFC46D12),
    FeedbackStatus.inProgress => const Color(0xFF1D6295),
    FeedbackStatus.resolved => const Color(0xFF0F6B5E),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(feedback.status);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    feedback.category,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    feedback.status.displayName,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              feedback.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(feedback.content, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 10),
            Text(
              'Gửi bởi: ${feedback.authorName} • ${DateFormatter.formatDateTime(feedback.createdAt)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (feedback.officialReply != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phản hồi từ Ban quản lý:',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      feedback.officialReply!,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
            if (canReply) ...[
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: onReplyTap,
                  icon: const Icon(Icons.reply_outlined, size: 18),
                  label: const Text('Phản hồi / Cập nhật'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
