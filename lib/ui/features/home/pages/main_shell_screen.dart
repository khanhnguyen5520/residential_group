import 'package:flutter/material.dart';

import '../../auth/view_models/auth_view_model.dart';
import '../../notifications/pages/notifications_tab.dart';
import '../../notifications/view_models/notifications_view_model.dart';
import '../../overview/pages/overview_tab.dart';
import '../../overview/subfeatures/feedback/view_models/feedback_view_model.dart';
import '../../overview/subfeatures/meetings/view_models/meetings_view_model.dart';
import '../../overview/subfeatures/news/view_models/news_view_model.dart';
import '../../overview/subfeatures/residents/view_models/resident_management_view_model.dart';
import '../../overview/subfeatures/surveys/view_models/surveys_view_model.dart';
import '../../profile/pages/profile_tab.dart';
import '../../profile/view_models/profile_view_model.dart';
import '../../settings/pages/settings_tab.dart';
import '../../settings/view_models/settings_view_model.dart';
import '../widgets/floating_bottom_nav_bar.dart';

/// Khung điều hướng 4 tab chính: Tổng quan, Thông báo, Cài đặt, Profile
/// với thanh điều hướng nổi (floating pill bottom navigation).
class MainShellScreen extends StatefulWidget {
  const MainShellScreen({
    super.key,
    required this.authViewModel,
    required this.notificationsViewModel,
    required this.settingsViewModel,
    required this.profileViewModel,
    required this.newsViewModel,
    required this.surveysViewModel,
    required this.feedbackViewModel,
    required this.meetingsViewModel,
    required this.residentManagementViewModel,
  });

  final AuthViewModel authViewModel;
  final NotificationsViewModel notificationsViewModel;
  final SettingsViewModel settingsViewModel;
  final ProfileViewModel profileViewModel;
  final NewsViewModel newsViewModel;
  final SurveysViewModel surveysViewModel;
  final FeedbackViewModel feedbackViewModel;
  final MeetingsViewModel meetingsViewModel;
  final ResidentManagementViewModel residentManagementViewModel;

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.authViewModel,
      builder: (context, _) {
        final currentUser = widget.authViewModel.currentUser;
        if (currentUser == null) {
          return const SizedBox.shrink();
        }

        return Scaffold(
          extendBody: true,
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              OverviewTab(
                currentUser: currentUser,
                newsViewModel: widget.newsViewModel,
                surveysViewModel: widget.surveysViewModel,
                feedbackViewModel: widget.feedbackViewModel,
                meetingsViewModel: widget.meetingsViewModel,
                residentManagementViewModel: widget.residentManagementViewModel,
              ),
              NotificationsTab(viewModel: widget.notificationsViewModel),
              SettingsTab(
                settingsViewModel: widget.settingsViewModel,
                authViewModel: widget.authViewModel,
              ),
              ProfileTab(viewModel: widget.profileViewModel),
            ],
          ),
          bottomNavigationBar: ListenableBuilder(
            listenable: widget.notificationsViewModel,
            builder: (context, _) {
              final unreadCount = widget.notificationsViewModel.unreadCount;
              return FloatingBottomNavBar(
                selectedIndex: _selectedIndex,
                unreadNotificationCount: unreadCount,
                onDestinationSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              );
            },
          ),
        );
      },
    );
  }
}
