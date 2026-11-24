import 'package:flutter/material.dart';
import 'package:residential_group/domain/models/meeting_schedule.dart';
import 'package:residential_group/ui/core/utils/date_formatter.dart';

import '../view_models/meetings_view_model.dart';

/// Màn hình Lịch họp dân cư, họp thôn và xác nhận tham dự.
/// Hỗ trợ chuyển đổi chế độ xem theo Ngày (danh sách) và Tháng (lịch tháng + danh sách sự kiện).
class MeetingsScreen extends StatefulWidget {
  const MeetingsScreen({
    super.key,
    required this.viewModel,
    required this.currentUserId,
    this.initialDate,
  });

  final MeetingsViewModel viewModel;
  final String currentUserId;
  final DateTime? initialDate;

  @override
  State<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen> {
  static const int _initialPage = 1200;

  bool _isMonthView = false;
  late final DateTime _today;
  late final DateTime _baseMonth;
  late DateTime _displayedMonth;
  late DateTime _selectedDate;
  late final PageController _monthPageController;

  @override
  void initState() {
    super.initState();
    final now = widget.initialDate ?? DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _baseMonth = DateTime(_today.year, _today.month);
    _displayedMonth = _baseMonth;
    _selectedDate = _today;
    _monthPageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _monthPageController.dispose();
    super.dispose();
  }

  DateTime _monthForPage(int page) {
    return DateTime(_baseMonth.year, _baseMonth.month + (page - _initialPage));
  }

  void _goToPreviousMonth() {
    if (_monthPageController.hasClients) {
      _monthPageController.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void _goToNextMonth() {
    if (_monthPageController.hasClients) {
      _monthPageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Set<DateTime> _meetingDateKeys(List<MeetingSchedule> meetings) {
    return meetings
        .map(
          (m) => DateTime(m.startTime.year, m.startTime.month, m.startTime.day),
        )
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch họp'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _isMonthView = false),
                  child: Text(
                    'Ngày',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: !_isMonthView
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: !_isMonthView
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Switch(
                  key: const ValueKey('meetings_view_switch'),
                  value: _isMonthView,
                  onChanged: (value) {
                    setState(() {
                      _isMonthView = value;
                    });
                  },
                ),
                GestureDetector(
                  onTap: () => setState(() => _isMonthView = true),
                  child: Text(
                    'Tháng',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: _isMonthView
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: _isMonthView
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          final meetings = widget.viewModel.meetings;
          if (!_isMonthView) {
            return _buildDayListView(meetings);
          }
          return _buildMonthView(context, meetings);
        },
      ),
    );
  }

  Widget _buildDayListView(List<MeetingSchedule> meetings) {
    if (meetings.isEmpty) {
      return const Center(child: Text('Hiện chưa có lịch họp nào.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: meetings.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final meeting = meetings[index];
        return _MeetingCard(
          meeting: meeting,
          isConfirmed: meeting.isConfirmedBy(widget.currentUserId),
          onToggleRsvp: () => widget.viewModel.toggleRsvp(
            meetingId: meeting.id,
            userId: widget.currentUserId,
          ),
        );
      },
    );
  }

  Widget _buildMonthView(BuildContext context, List<MeetingSchedule> meetings) {
    final theme = Theme.of(context);
    final meetingDates = _meetingDateKeys(meetings);
    final selectedDayMeetings =
        meetings
            .where((meeting) => _isSameDay(meeting.startTime, _selectedDate))
            .toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Card(
            key: const ValueKey('calendar_month_panel'),
            margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        key: const ValueKey('calendar_prev_month'),
                        tooltip: 'Tháng trước',
                        visualDensity: VisualDensity.compact,
                        onPressed: _goToPreviousMonth,
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Expanded(
                        child: Text(
                          'Tháng ${_displayedMonth.month} / ${_displayedMonth.year}',
                          key: const ValueKey('calendar_month_title'),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        key: const ValueKey('calendar_next_month'),
                        tooltip: 'Tháng sau',
                        visualDensity: VisualDensity.compact,
                        onPressed: _goToNextMonth,
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        _WeekdayLabel('T2'),
                        _WeekdayLabel('T3'),
                        _WeekdayLabel('T4'),
                        _WeekdayLabel('T5'),
                        _WeekdayLabel('T6'),
                        _WeekdayLabel('T7'),
                        _WeekdayLabel('CN'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      key: const ValueKey('calendar_month_pageview'),
                      controller: _monthPageController,
                      onPageChanged: (page) {
                        setState(() {
                          _displayedMonth = _monthForPage(page);
                        });
                      },
                      itemBuilder: (context, page) {
                        final month = _monthForPage(page);
                        return _MonthCalendarGrid(
                          month: month,
                          today: _today,
                          selectedDate: _selectedDate,
                          meetingDates: meetingDates,
                          onSelectDate: (date) {
                            setState(() {
                              _selectedDate = date;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            key: const ValueKey('calendar_events_panel'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                child: Row(
                  children: [
                    Icon(
                      Icons.event_note_outlined,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Ngày ${DateFormatter.formatDate(_selectedDate)}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${selectedDayMeetings.length} cuộc họp',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: selectedDayMeetings.isEmpty
                    ? Center(
                        child: Text(
                          'Không có cuộc họp vào ngày này',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        itemCount: selectedDayMeetings.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final meeting = selectedDayMeetings[index];
                          return _MeetingCard(
                            meeting: meeting,
                            isConfirmed: meeting.isConfirmedBy(
                              widget.currentUserId,
                            ),
                            onToggleRsvp: () => widget.viewModel.toggleRsvp(
                              meetingId: meeting.id,
                              userId: widget.currentUserId,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  const _WeekdayLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _MonthCalendarGrid extends StatelessWidget {
  const _MonthCalendarGrid({
    required this.month,
    required this.today,
    required this.selectedDate,
    required this.meetingDates,
    required this.onSelectDate,
  });

  final DateTime month;
  final DateTime today;
  final DateTime selectedDate;
  final Set<DateTime> meetingDates;
  final ValueChanged<DateTime> onSelectDate;

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final leadingEmptyCells = firstDayOfMonth.weekday - 1;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    return Column(
      children: List<Widget>.generate(6, (rowIndex) {
        return Expanded(
          child: Row(
            children: List<Widget>.generate(7, (colIndex) {
              final cellIndex = rowIndex * 7 + colIndex;
              final dayNumber = cellIndex - leadingEmptyCells + 1;
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const Expanded(child: SizedBox.shrink());
              }

              final date = DateTime(month.year, month.month, dayNumber);
              final isSelected = _isSameDay(date, selectedDate);
              final isToday = _isSameDay(date, today);
              final hasMeeting = meetingDates.contains(date);

              return Expanded(
                child: InkWell(
                  key: ValueKey(
                    'calendar_day_${date.year}_${date.month}_${date.day}',
                  ),
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => onSelectDate(date),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : isToday
                                ? theme.colorScheme.primary.withValues(
                                    alpha: 0.14,
                                  )
                                : null,
                            border: isToday && !isSelected
                                ? Border.all(
                                    color: theme.colorScheme.primary,
                                    width: 1.2,
                                  )
                                : null,
                          ),
                          child: Text(
                            '$dayNumber',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: isSelected || isToday
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? theme.colorScheme.onPrimary
                                  : isToday
                                  ? theme.colorScheme.primary
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          key: hasMeeting
                              ? ValueKey(
                                  'calendar_dot_${date.year}_${date.month}_${date.day}',
                                )
                              : null,
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasMeeting
                                ? theme.colorScheme.primary
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

class _MeetingCard extends StatelessWidget {
  const _MeetingCard({
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
