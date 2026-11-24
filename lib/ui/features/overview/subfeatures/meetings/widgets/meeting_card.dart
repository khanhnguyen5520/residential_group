import 'package:flutter/material.dart';
import 'package:residential_group/domain/models/meeting_schedule.dart';
import 'package:residential_group/ui/core/utils/date_formatter.dart';

/// Thẻ hiển thị thông tin một cuộc họp và nút xác nhận tham dự.
class MeetingCard extends StatelessWidget {
  const MeetingCard({
    super.key,
    required this.meeting,
    required this.isConfirmed,
    required this.onToggleRsvp,
  });

  final MeetingSchedule meeting;
  final bool isConfirmed;
  final VoidCallback onToggleRsvp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPast = meeting.endTime.isBefore(DateTime.now());

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
                        (isPast
                                ? theme.colorScheme.outline
                                : theme.colorScheme.primary)
                            .withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isPast ? 'Đã diễn ra' : 'Sắp diễn ra',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isPast
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(meeting.scope),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              meeting.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              meeting.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.schedule_outlined,
              text:
                  '${DateFormatter.formatDate(meeting.startTime)} • '
                  '${DateFormatter.formatTime(meeting.startTime)} - '
                  '${DateFormatter.formatTime(meeting.endTime)}',
            ),
            const SizedBox(height: 6),
            _InfoRow(icon: Icons.location_on_outlined, text: meeting.location),
            const SizedBox(height: 6),
            _InfoRow(
              icon: Icons.record_voice_over_outlined,
              text: 'Chủ trì: ${meeting.hostName}',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.people_outline,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${meeting.confirmedUserIds.length} người đã xác nhận',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (!isPast)
                  isConfirmed
                      ? FilledButton.tonalIcon(
                          onPressed: onToggleRsvp,
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Đã xác nhận'),
                        )
                      : FilledButton.icon(
                          onPressed: onToggleRsvp,
                          icon: const Icon(Icons.event_available_outlined),
                          label: const Text('Xác nhận tham dự'),
                        ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}
