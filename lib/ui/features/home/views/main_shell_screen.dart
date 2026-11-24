import 'package:flutter/material.dart';

import '../../auth/view_models/auth_view_model.dart';
import '../../notifications/view_models/notifications_view_model.dart';
import '../../notifications/views/notifications_tab.dart';
import '../../overview/subfeatures/feedback/view_models/feedback_view_model.dart';
import '../../overview/subfeatures/meetings/view_models/meetings_view_model.dart';
import '../../overview/subfeatures/news/view_models/news_view_model.dart';
import '../../overview/subfeatures/residents/view_models/resident_management_view_model.dart';
import '../../overview/subfeatures/surveys/view_models/surveys_view_model.dart';
import '../../overview/views/overview_tab.dart';
import '../../profile/view_models/profile_view_model.dart';
import '../../profile/views/profile_tab.dart';
import '../../settings/view_models/settings_view_model.dart';
import '../../settings/views/settings_tab.dart';

/// Khung điều hướng 4 tab chính: Tổng quan, Thông báo, Cài đặt, Profile.
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
              return NavigationBar(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                destinations: [
                  const NavigationDestination(
                    icon: Icon(Icons.dashboard_outlined),
                    selectedIcon: Icon(Icons.dashboard_rounded),
                    label: 'Tổng quan',
                  ),
                  NavigationDestination(
                    icon: Badge.count(
                      count: unreadCount,
                      isLabelVisible: unreadCount > 0,
                      child: const Icon(Icons.notifications_outlined),
                    ),
                    selectedIcon: Badge.count(
                      count: unreadCount,
                      isLabelVisible: unreadCount > 0,
                      child: const Icon(Icons.notifications_rounded),
                    ),
                    label: 'Thông báo',
                  ),
                  const NavigationDestination(
                    icon: Icon(Icons.settings_outlined),
                    selectedIcon: Icon(Icons.settings_rounded),
                    label: 'Cài đặt',
                  ),
                  const NavigationDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person_rounded),
                    label: 'Profile',
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
