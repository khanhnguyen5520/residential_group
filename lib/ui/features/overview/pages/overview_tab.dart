import 'package:flutter/material.dart';

import '../../../../domain/models/resident_account.dart';
import '../subfeatures/feedback/pages/feedback_screen.dart';
import '../subfeatures/feedback/view_models/feedback_view_model.dart';
import '../subfeatures/meetings/pages/meetings_screen.dart';
import '../subfeatures/meetings/view_models/meetings_view_model.dart';
import '../subfeatures/news/pages/news_screen.dart';
import '../subfeatures/news/view_models/news_view_model.dart';
import '../subfeatures/residents/pages/resident_management_screen.dart';
import '../subfeatures/residents/view_models/resident_management_view_model.dart';
import '../subfeatures/surveys/pages/surveys_screen.dart';
import '../subfeatures/surveys/view_models/surveys_view_model.dart';
import '../widgets/account_header_card.dart';
import '../widgets/feature_grid_card.dart';

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
    final items = <OverviewAction>[
      OverviewAction(
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
      OverviewAction(
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
      OverviewAction(
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
      OverviewAction(
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
        OverviewAction(
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
              child: AccountHeaderCard(currentUser: currentUser),
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
            padding: EdgeInsets.fromLTRB(
              16,
              0,
              16,
              MediaQuery.paddingOf(context).bottom + 40,
            ),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 136,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => FeatureGridCard(action: items[index]),
                childCount: items.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
