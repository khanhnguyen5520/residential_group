import 'package:flutter/material.dart';

import 'data/repositories/auth_repository.dart';
import 'data/repositories/community_repository.dart';
import 'data/repositories/notification_repository.dart';
import 'data/repositories/resident_repository.dart';
import 'data/services/in_memory_commune_service.dart';
import 'ui/core/theme/app_theme.dart';
import 'ui/features/auth/pages/login_screen.dart';
import 'ui/features/auth/view_models/auth_view_model.dart';
import 'ui/features/home/pages/main_shell_screen.dart';
import 'ui/features/notifications/view_models/notifications_view_model.dart';
import 'ui/features/overview/subfeatures/feedback/view_models/feedback_view_model.dart';
import 'ui/features/overview/subfeatures/meetings/view_models/meetings_view_model.dart';
import 'ui/features/overview/subfeatures/news/view_models/news_view_model.dart';
import 'ui/features/overview/subfeatures/residents/view_models/resident_management_view_model.dart';
import 'ui/features/overview/subfeatures/surveys/view_models/surveys_view_model.dart';
import 'ui/features/profile/view_models/profile_view_model.dart';
import 'ui/features/settings/view_models/settings_view_model.dart';

/// Khởi tạo và gắn kết toàn bộ dependency theo kiến trúc phân tầng Repository + MVVM.
class AppDependencies {
  AppDependencies({DateTime? seedReferenceTime}) {
    service = InMemoryCommuneService(seedReferenceTime: seedReferenceTime);
    authRepository = AuthRepository(service: service);
    residentRepository = ResidentRepository(service: service);
    notificationRepository = NotificationRepository(service: service);
    communityRepository = CommunityRepository(service: service);

    authViewModel = AuthViewModel(authRepository: authRepository);
    settingsViewModel = SettingsViewModel();
    notificationsViewModel = NotificationsViewModel(
      notificationRepository: notificationRepository,
    );
    profileViewModel = ProfileViewModel(
      authRepository: authRepository,
      authViewModel: authViewModel,
    );
    newsViewModel = NewsViewModel(communityRepository: communityRepository);
    surveysViewModel = SurveysViewModel(
      communityRepository: communityRepository,
    );
    feedbackViewModel = FeedbackViewModel(
      communityRepository: communityRepository,
    );
    meetingsViewModel = MeetingsViewModel(
      communityRepository: communityRepository,
    );
    residentManagementViewModel = ResidentManagementViewModel(
      residentRepository: residentRepository,
      authViewModel: authViewModel,
      onResidentsChanged: notificationsViewModel.refresh,
    );
  }

  late final InMemoryCommuneService service;
  late final AuthRepository authRepository;
  late final ResidentRepository residentRepository;
  late final NotificationRepository notificationRepository;
  late final CommunityRepository communityRepository;

  late final AuthViewModel authViewModel;
  late final SettingsViewModel settingsViewModel;
  late final NotificationsViewModel notificationsViewModel;
  late final ProfileViewModel profileViewModel;
  late final NewsViewModel newsViewModel;
  late final SurveysViewModel surveysViewModel;
  late final FeedbackViewModel feedbackViewModel;
  late final MeetingsViewModel meetingsViewModel;
  late final ResidentManagementViewModel residentManagementViewModel;

  void reloadAll() {
    notificationsViewModel.refresh();
    newsViewModel.load();
    surveysViewModel.load();
    feedbackViewModel.load();
    meetingsViewModel.load();
    residentManagementViewModel.load();
  }

  void dispose() {
    authViewModel.dispose();
    settingsViewModel.dispose();
    notificationsViewModel.dispose();
    profileViewModel.dispose();
    newsViewModel.dispose();
    surveysViewModel.dispose();
    feedbackViewModel.dispose();
    meetingsViewModel.dispose();
    residentManagementViewModel.dispose();
  }
}

/// Widget gốc của ứng dụng Quản lý Dân cư Xã.
class ResidentialApp extends StatefulWidget {
  const ResidentialApp({super.key, this.dependencies});

  final AppDependencies? dependencies;

  @override
  State<ResidentialApp> createState() => _ResidentialAppState();
}

class _ResidentialAppState extends State<ResidentialApp> {
  late final AppDependencies _dependencies;
  late final bool _ownsDependencies;

  @override
  void initState() {
    super.initState();
    _ownsDependencies = widget.dependencies == null;
    _dependencies = widget.dependencies ?? AppDependencies();
  }

  @override
  void dispose() {
    if (_ownsDependencies) {
      _dependencies.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _dependencies.settingsViewModel,
      builder: (context, _) {
        return MaterialApp(
          title: 'Quản lý Dân cư Xã',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _dependencies.settingsViewModel.themeMode,
          home: ListenableBuilder(
            listenable: _dependencies.authViewModel,
            builder: (context, _) {
              if (!_dependencies.authViewModel.isAuthenticated) {
                return LoginScreen(
                  viewModel: _dependencies.authViewModel,
                  onAfterResetDemo: _dependencies.reloadAll,
                );
              }
              return MainShellScreen(
                authViewModel: _dependencies.authViewModel,
                notificationsViewModel: _dependencies.notificationsViewModel,
                settingsViewModel: _dependencies.settingsViewModel,
                profileViewModel: _dependencies.profileViewModel,
                newsViewModel: _dependencies.newsViewModel,
                surveysViewModel: _dependencies.surveysViewModel,
                feedbackViewModel: _dependencies.feedbackViewModel,
                meetingsViewModel: _dependencies.meetingsViewModel,
                residentManagementViewModel:
                    _dependencies.residentManagementViewModel,
              );
            },
          ),
        );
      },
    );
  }
}
