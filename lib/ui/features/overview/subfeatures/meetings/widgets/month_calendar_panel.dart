import 'package:flutter/material.dart';

/// Khung lịch tháng hỗ trợ lướt ngang giữa các tháng và đánh dấu ngày có lịch họp.
class MonthCalendarPanel extends StatelessWidget {
  const MonthCalendarPanel({
    super.key,
    required this.displayedMonth,
    required this.today,
    required this.selectedDate,
    required this.meetingDates,
    required this.pageController,
    required this.monthForPage,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onPageChanged,
    required this.onSelectDate,
  });

  final DateTime displayedMonth;
  final DateTime today;
  final DateTime selectedDate;
  final Set<DateTime> meetingDates;
  final PageController pageController;
  final DateTime Function(int page) monthForPage;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<DateTime> onSelectDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
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
                  onPressed: onPreviousMonth,
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(
                    'Tháng ${displayedMonth.month} / ${displayedMonth.year}',
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
                  onPressed: onNextMonth,
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
                controller: pageController,
                onPageChanged: onPageChanged,
                itemBuilder: (context, page) {
                  return _MonthCalendarGrid(
                    month: monthForPage(page),
                    today: today,
                    selectedDate: selectedDate,
                    meetingDates: meetingDates,
                    onSelectDate: onSelectDate,
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
