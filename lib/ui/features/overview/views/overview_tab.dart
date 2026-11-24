import 'package:flutter/material.dart';

import '../../../../domain/models/resident_account.dart';
import '../../../../domain/models/user_role.dart';
import '../../../core/widgets/role_badge.dart';
import '../../../core/widgets/user_avatar.dart';
import '../subfeatures/feedback/view_models/feedback_view_model.dart';
import '../subfeatures/feedback/views/feedback_screen.dart';
import '../subfeatures/meetings/view_models/meetings_view_model.dart';
import '../subfeatures/meetings/views/meetings_screen.dart';
import '../subfeatures/news/view_models/news_view_model.dart';
import '../subfeatures/news/views/news_screen.dart';
import '../subfeatures/residents/view_models/resident_management_view_model.dart';
import '../subfeatures/residents/views/resident_management_screen.dart';
import '../subfeatures/surveys/view_models/surveys_view_model.dart';
import '../subfeatures/surveys/views/surveys_screen.dart';

/// Tab 1 — Màn Tổng quan: trên cùng là tên chủ tài khoản & avatar, bên dưới là lưới chức năng.
class OverviewTab extends StatelessWidget {
  const OverviewTab({
    super.key,
    required this.currentUser,
    required this.newsViewModel,
    required this.surveysViewModel,
    required this.feedbackViewModel,
    required this.meetingsViewModel,
    required this.residentManagementViewModel,
  });

  final ResidentAccount currentUser;
  final NewsViewModel newsViewModel;
  final SurveysViewModel surveysViewModel;
  final FeedbackViewModel feedbackViewModel;
  final MeetingsViewModel meetingsViewModel;
  final ResidentManagementViewModel residentManagementViewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = <_OverviewAction>[
      _OverviewAction(
        key: const ValueKey('overview_feature_news'),
        title: 'Tin tức',
        subtitle: 'Thông tin & văn bản xã',
        icon: Icons.newspaper_rounded,
        color: const Color(0xFF0F6B5E),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => NewsScreen(viewModel: newsViewModel),
          ),
        ),
      ),
      _OverviewAction(
        key: const ValueKey('overview_feature_surveys'),
        title: 'Khảo sát',
        subtitle: 'Bình chọn ý kiến cộng đồng',
        icon: Icons.poll_outlined,
        color: const Color(0xFF1D6295),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => SurveysScreen(
              viewModel: surveysViewModel,
              currentUserId: currentUser.id,
            ),
          ),
        ),
      ),
      _OverviewAction(
        key: const ValueKey('overview_feature_feedback'),
        title: 'Ý kiến',
        subtitle: 'Kiến nghị & phản ánh',
        icon: Icons.forum_outlined,
        color: const Color(0xFFC46D12),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => FeedbackScreen(
              viewModel: feedbackViewModel,
              currentUser: currentUser,
            ),
          ),
        ),
      ),
      _OverviewAction(
        key: const ValueKey('overview_feature_meetings'),
        title: 'Lịch họp',
        subtitle: 'Họp thôn & lịch công tác',
        icon: Icons.calendar_month_outlined,
        color: const Color(0xFF6A4C93),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => MeetingsScreen(
              viewModel: meetingsViewModel,
              currentUserId: currentUser.id,
            ),
          ),
        ),
      ),
      if (currentUser.role.canManageResidents)
        _OverviewAction(
          key: const ValueKey('overview_feature_residents'),
          title: 'Quản lý cư dân',
          subtitle: 'Thêm, sửa, xoá hồ sơ',
          icon: Icons.manage_accounts_outlined,
          color: const Color(0xFFB3261E),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ResidentManagementScreen(
                viewModel: residentManagementViewModel,
                currentUser: currentUser,
              ),
            ),
          ),
        ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Tổng quan')),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            sliver: SliverToBoxAdapter(
              child: _AccountHeaderCard(currentUser: currentUser),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Chức năng',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 136,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _FeatureGridCard(action: items[index]),
                childCount: items.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountHeaderCard extends StatelessWidget {
  const _AccountHeaderCard({required this.currentUser});

  final ResidentAccount currentUser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            UserAvatar(account: currentUser, radius: 30),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentUser.fullName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      RoleBadge(role: currentUser.role),
                      Text(
                        '${currentUser.village} • Xã Tân Lập',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  if (currentUser.role == UserRole.villageHead) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Quyền điều hành ngang hàng Admin',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewAction {
  const _OverviewAction({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final Key key;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}

class _FeatureGridCard extends StatelessWidget {
  const _FeatureGridCard({required this.action});

  final _OverviewAction action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        key: action.key,
        borderRadius: BorderRadius.circular(16),
        onTap: action.onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: action.color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(action.icon, color: action.color, size: 26),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    action.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
