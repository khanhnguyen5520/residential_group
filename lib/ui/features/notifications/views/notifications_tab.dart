import 'package:flutter/material.dart';

import '../../../../domain/models/app_notification.dart';
import '../../../../domain/models/notification_filter.dart';
import '../../../core/utils/date_formatter.dart';
import '../view_models/notifications_view_model.dart';

/// Tab 2 — Màn Thông báo: danh sách thông báo có bộ lọc thời gian và trình sắp xếp thứ tự.
class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key, required this.viewModel});

  final NotificationsViewModel viewModel;

  Future<void> _handleCustomRange(BuildContext context) async {
    final now = DateTime.now();
    final initial =
        viewModel.customRange ??
        DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
      initialDateRange: initial,
      helpText: 'Chọn khoảng thời gian lọc thông báo',
      saveText: 'Áp dụng',
    );
    if (picked != null) {
      viewModel.setCustomRange(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        actions: [
          ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) {
              if (viewModel.unreadCount == 0) {
                return const SizedBox.shrink();
              }
              return TextButton.icon(
                onPressed: viewModel.markAllAsRead,
                icon: const Icon(Icons.done_all_rounded, size: 18),
                label: const Text('Đọc tất cả'),
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          final items = viewModel.notifications;
          final customRange = viewModel.customRange;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 52,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: NotificationTimeFilter.values.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final filter = NotificationTimeFilter.values[index];
                    final isSelected = viewModel.timeFilter == filter;
                    return ChoiceChip(
                      key: ValueKey('notification_filter_${filter.name}'),
                      label: Text(filter.displayName),
                      selected: isSelected,
                      onSelected: (_) {
                        if (filter == NotificationTimeFilter.customRange) {
                          _handleCustomRange(context);
                        } else {
                          viewModel.setTimeFilter(filter);
                        }
                      },
                    );
                  },
                ),
              ),
              if (viewModel.timeFilter == NotificationTimeFilter.customRange &&
                  customRange != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.date_range_outlined,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Từ ${DateFormatter.formatDate(customRange.start)} '
                        'đến ${DateFormatter.formatDate(customRange.end)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _handleCustomRange(context),
                        child: const Text('Đổi ngày'),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                child: Row(
                  children: [
                    Text(
                      '${items.length} thông báo',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    SegmentedButton<NotificationSortOrder>(
                      key: const ValueKey('notification_sort_segmented'),
                      showSelectedIcon: false,
                      style: const ButtonStyle(
                        visualDensity: VisualDensity.compact,
                      ),
                      segments: NotificationSortOrder.values.map((order) {
                        return ButtonSegment<NotificationSortOrder>(
                          value: order,
                          label: Text(order.displayName),
                        );
                      }).toList(),
                      selected: <NotificationSortOrder>{viewModel.sortOrder},
                      onSelectionChanged: (selection) {
                        viewModel.setSortOrder(selection.first);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.notifications_off_outlined,
                                size: 48,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Không có thông báo nào trong khoảng thời gian đã chọn.',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final notification = items[index];
                          return _NotificationCard(
                            notification: notification,
                            onTap: () {
                              viewModel.markAsRead(notification.id);
                              _openDetail(context, notification);
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openDetail(BuildContext context, AppNotification notification) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Chip(
                label: Text(notification.category.displayName),
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(height: 8),
              Text(
                notification.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                DateFormatter.formatDateTime(notification.createdAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Divider(height: 20),
              Text(
                notification.body,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  IconData _iconFor(NotificationCategory category) => switch (category) {
    NotificationCategory.general => Icons.campaign_outlined,
    NotificationCategory.news => Icons.newspaper_outlined,
    NotificationCategory.survey => Icons.poll_outlined,
    NotificationCategory.meeting => Icons.event_outlined,
    NotificationCategory.resident => Icons.people_outline,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnread = !notification.isRead;

    return Card(
      key: ValueKey('notification_item_${notification.id}'),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(
                    alpha: isUnread ? 0.16 : 0.08,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _iconFor(notification.category),
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          notification.category.displayName,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          DateFormatter.formatDateTime(notification.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 11.5,
                          ),
                        ),
                        if (isUnread) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: isUnread
                            ? FontWeight.w700
                            : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
