import 'package:flutter/material.dart';
import 'package:residential_group/domain/models/meeting_schedule.dart';
import 'package:residential_group/ui/core/utils/date_formatter.dart';

import '../view_models/meetings_view_model.dart';
import '../widgets/meeting_card.dart';
import '../widgets/month_calendar_panel.dart';

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
        return MeetingCard(
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
          child: MonthCalendarPanel(
            displayedMonth: _displayedMonth,
            today: _today,
            selectedDate: _selectedDate,
            meetingDates: meetingDates,
            pageController: _monthPageController,
            monthForPage: _monthForPage,
            onPreviousMonth: _goToPreviousMonth,
            onNextMonth: _goToNextMonth,
            onPageChanged: (page) {
              setState(() {
                _displayedMonth = _monthForPage(page);
              });
            },
            onSelectDate: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
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
                          return MeetingCard(
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
