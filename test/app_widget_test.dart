import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:residential_group/app.dart';
import 'package:residential_group/domain/models/user_role.dart';
import 'package:residential_group/ui/features/overview/pages/overview_tab.dart';
import 'package:residential_group/ui/features/overview/subfeatures/meetings/pages/meetings_screen.dart';

void main() {
  Future<void> pumpApp(
    WidgetTester tester, {
    DateTime? seedReferenceTime,
  }) async {
    await tester.pumpWidget(
      ResidentialApp(
        dependencies: AppDependencies(seedReferenceTime: seedReferenceTime),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> quickLogin(WidgetTester tester, UserRole role) async {
    final finder = find.byKey(ValueKey('quick_login_${role.name}'));
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> navigateToTab(WidgetTester tester, String label) async {
    final destination = find.descendant(
      of: find.byKey(const ValueKey('floating_bottom_nav')),
      matching: find.text(label),
    );
    await tester.tap(destination);
    await tester.pumpAndSettle();
  }

  Future<void> scrollOverviewTo(WidgetTester tester, Finder target) async {
    await tester.scrollUntilVisible(
      target,
      150,
      scrollable: find.descendant(
        of: find.byType(OverviewTab),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('Phân cấp tài khoản trên màn Tổng quan', () {
    testWidgets(
      'Admin và Trưởng thôn thấy đầy đủ 5 chức năng kể cả Quản lý cư dân',
      (tester) async {
        await pumpApp(tester);
        await quickLogin(tester, UserRole.admin);

        expect(find.text('Nguyễn Văn An'), findsOneWidget);
        expect(find.text('Tin tức'), findsOneWidget);
        expect(find.text('Khảo sát'), findsOneWidget);
        expect(find.text('Ý kiến'), findsOneWidget);
        expect(find.text('Lịch họp'), findsOneWidget);
        await scrollOverviewTo(tester, find.text('Quản lý cư dân'));
        expect(find.text('Quản lý cư dân'), findsOneWidget);

        await navigateToTab(tester, 'Cài đặt');
        await tester.tap(find.byKey(const ValueKey('settings_logout_tile')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const ValueKey('confirm_logout_button')));
        await tester.pumpAndSettle();

        await quickLogin(tester, UserRole.villageHead);
        expect(find.text('Trần Thị Bình'), findsOneWidget);
        await scrollOverviewTo(tester, find.text('Quản lý cư dân'));
        expect(find.text('Quản lý cư dân'), findsOneWidget);
      },
    );

    testWidgets(
      'Phó thôn và Cư dân chỉ thấy 4 chức năng, không thấy Quản lý cư dân',
      (tester) async {
        await pumpApp(tester);
        await quickLogin(tester, UserRole.deputyHead);

        expect(find.text('Lê Minh Cường'), findsOneWidget);
        expect(find.text('Tin tức'), findsOneWidget);
        expect(find.text('Khảo sát'), findsOneWidget);
        expect(find.text('Ý kiến'), findsOneWidget);
        expect(find.text('Lịch họp'), findsOneWidget);
        expect(find.text('Quản lý cư dân'), findsNothing);

        await navigateToTab(tester, 'Cài đặt');
        await tester.tap(find.byKey(const ValueKey('settings_logout_tile')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const ValueKey('confirm_logout_button')));
        await tester.pumpAndSettle();

        await quickLogin(tester, UserRole.resident);
        expect(find.text('Phạm Thu Dung'), findsOneWidget);
        expect(find.text('Quản lý cư dân'), findsNothing);
      },
    );
  });

  group('Quản lý cư dân (Thêm, Sửa, Xoá)', () {
    testWidgets('Trưởng thôn thêm, sửa và xoá cư dân thành công', (
      tester,
    ) async {
      await pumpApp(tester);
      await quickLogin(tester, UserRole.villageHead);

      final residentCard = find.byKey(
        const ValueKey('overview_feature_residents'),
      );
      await scrollOverviewTo(tester, residentCard);
      await tester.tap(residentCard);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('add_resident_fab')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('resident_form_name')),
        'Hoàng Anh Tuấn',
      );
      await tester.enterText(
        find.byKey(const ValueKey('resident_form_cccd')),
        '036091000111',
      );
      await tester.enterText(
        find.byKey(const ValueKey('resident_form_phone')),
        '0912345678',
      );
      await tester.enterText(
        find.byKey(const ValueKey('resident_form_address')),
        'Số 15, Thôn Đoài, Xã Tân Lập',
      );

      final submitBtn = find.byKey(const ValueKey('resident_form_submit'));
      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      expect(find.text('Hoàng Anh Tuấn'), findsOneWidget);

      await tester.enterText(
        find.byKey(const ValueKey('resident_search_field')),
        '036091000111',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sửa').first);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('resident_form_name')),
        'Hoàng Anh Tuấn Cập Nhật',
      );
      await tester.ensureVisible(submitBtn);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      expect(find.text('Quản lý cư dân'), findsOneWidget);
      expect(find.text('Hoàng Anh Tuấn Cập Nhật'), findsOneWidget);

      await tester.tap(find.text('Xoá').first);
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('confirm_delete_resident_btn')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Hoàng Anh Tuấn Cập Nhật'), findsNothing);
    });
  });

  group('Tab Thông báo: Bộ lọc thời gian và Trình sắp xếp', () {
    testWidgets(
      'Lọc thời gian và đảo thứ tự Mới nhất / Cũ nhất hoạt động đúng',
      (tester) async {
        await pumpApp(tester, seedReferenceTime: DateTime.now());
        await quickLogin(tester, UserRole.resident);
        await navigateToTab(tester, 'Thông báo');

        expect(find.text('7 thông báo'), findsOneWidget);

        final noti1Top = tester
            .getTopLeft(find.byKey(const ValueKey('notification_item_noti-1')))
            .dy;
        final noti7Search = find.byKey(
          const ValueKey('notification_item_noti-7'),
        );
        if (noti7Search.evaluate().isNotEmpty) {
          expect(noti1Top, lessThan(tester.getTopLeft(noti7Search).dy));
        }

        await tester.tap(find.text('Cũ nhất'));
        await tester.pumpAndSettle();
        expect(
          find.byKey(const ValueKey('notification_item_noti-7')),
          findsOneWidget,
        );

        await tester.tap(
          find.byKey(const ValueKey('notification_filter_today')),
        );
        await tester.pumpAndSettle();
        expect(find.text('2 thông báo'), findsOneWidget);

        await tester.tap(
          find.byKey(const ValueKey('notification_filter_last7Days')),
        );
        await tester.pumpAndSettle();
        expect(find.text('4 thông báo'), findsOneWidget);

        await tester.tap(
          find.byKey(const ValueKey('notification_filter_last30Days')),
        );
        await tester.pumpAndSettle();
        expect(find.text('6 thông báo'), findsOneWidget);
      },
    );
  });

  group('Tab Cài đặt & Tab Profile', () {
    testWidgets(
      'Cài đặt hiển thị đủ 6 mục, đổi Chế độ sáng, đổi mật khẩu và xoá tài khoản',
      (tester) async {
        await pumpApp(tester);
        await quickLogin(tester, UserRole.resident);
        await navigateToTab(tester, 'Cài đặt');

        expect(find.text('Chế độ sáng'), findsOneWidget);
        expect(find.text('Thông tin ứng dụng'), findsOneWidget);
        expect(find.text('Điều khoản sử dụng'), findsOneWidget);
        expect(find.text('Đổi mật khẩu'), findsOneWidget);
        expect(find.text('Đăng xuất'), findsOneWidget);
        expect(find.text('Xoá tài khoản'), findsOneWidget);

        MaterialApp app = tester.widget<MaterialApp>(find.byType(MaterialApp));
        expect(app.themeMode, ThemeMode.light);

        await tester.tap(
          find.byKey(const ValueKey('settings_light_mode_switch')),
        );
        await tester.pumpAndSettle();
        app = tester.widget<MaterialApp>(find.byType(MaterialApp));
        expect(app.themeMode, ThemeMode.dark);

        await tester.tap(
          find.byKey(const ValueKey('settings_change_password_tile')),
        );
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const ValueKey('change_pw_current')),
          '123456',
        );
        await tester.enterText(
          find.byKey(const ValueKey('change_pw_new')),
          'matkhau99',
        );
        await tester.enterText(
          find.byKey(const ValueKey('change_pw_confirm')),
          'matkhau99',
        );
        await tester.tap(find.byKey(const ValueKey('change_pw_submit')));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const ValueKey('settings_logout_tile')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const ValueKey('confirm_logout_button')));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const ValueKey('login_identifier_field')),
          '0901000004',
        );
        await tester.enterText(
          find.byKey(const ValueKey('login_password_field')),
          'matkhau99',
        );
        await tester.ensureVisible(
          find.byKey(const ValueKey('login_submit_button')),
        );
        await tester.tap(find.byKey(const ValueKey('login_submit_button')));
        await tester.pumpAndSettle();

        expect(find.text('Phạm Thu Dung'), findsOneWidget);

        await navigateToTab(tester, 'Cài đặt');
        await tester.tap(
          find.byKey(const ValueKey('settings_delete_account_tile')),
        );
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const ValueKey('delete_account_password_field')),
          'matkhau99',
        );
        await tester.tap(
          find.byKey(const ValueKey('confirm_delete_account_button')),
        );
        await tester.pumpAndSettle();

        expect(find.text('Đăng nhập hệ thống'), findsOneWidget);
        await tester.enterText(
          find.byKey(const ValueKey('login_identifier_field')),
          '0901000004',
        );
        await tester.enterText(
          find.byKey(const ValueKey('login_password_field')),
          'matkhau99',
        );
        await tester.ensureVisible(
          find.byKey(const ValueKey('login_submit_button')),
        );
        await tester.tap(find.byKey(const ValueKey('login_submit_button')));
        await tester.pumpAndSettle();
        expect(
          find.text('Không tìm thấy tài khoản khớp với số điện thoại/CCCD.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Profile hiển thị đầy đủ thông tin và chỉnh sửa đồng bộ với Tổng quan',
      (tester) async {
        await pumpApp(tester);
        await quickLogin(tester, UserRole.resident);
        await navigateToTab(tester, 'Profile');

        expect(find.text('Phạm Thu Dung'), findsAtLeastNWidgets(1));
        expect(
          find.byKey(const ValueKey('edit_profile_button')),
          findsOneWidget,
        );
        expect(find.text('Căn cước công dân'), findsOneWidget);
        expect(find.text('036195000004'), findsOneWidget);
        expect(find.text('Số điện thoại'), findsOneWidget);
        expect(find.text('0901000004'), findsOneWidget);
        expect(find.text('Địa chỉ'), findsOneWidget);
        expect(find.text('Thông tin hộ gia đình'), findsOneWidget);
        expect(find.text('HK-TL-0004'), findsOneWidget);
        expect(find.text('Phạm Văn Hùng'), findsAtLeastNWidgets(1));

        await tester.tap(find.byKey(const ValueKey('edit_profile_button')));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const ValueKey('edit_profile_name')),
          'Phạm Thu Dung Mới',
        );
        await tester.enterText(
          find.byKey(const ValueKey('edit_profile_address')),
          'Số 99, Đường Mới, Thôn Bắc, Xã Tân Lập',
        );
        final saveBtn = find.byKey(const ValueKey('edit_profile_save'));
        await tester.ensureVisible(saveBtn);
        await tester.tap(saveBtn);
        await tester.pumpAndSettle();

        expect(find.text('Phạm Thu Dung Mới'), findsOneWidget);
        expect(
          find.text('Số 99, Đường Mới, Thôn Bắc, Xã Tân Lập'),
          findsOneWidget,
        );

        await navigateToTab(tester, 'Tổng quan');
        expect(find.text('Phạm Thu Dung Mới'), findsOneWidget);
      },
    );
  });

  group('Màn Ý kiến (FeedbackScreen)', () {
    testWidgets(
      'Nhập tiêu đề, nội dung rồi bấm Huỷ không gây lỗi và gửi ý kiến thành công',
      (tester) async {
        await pumpApp(tester);
        await quickLogin(tester, UserRole.resident);

        await tester.tap(
          find.byKey(const ValueKey('overview_feature_feedback')),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Gửi ý kiến'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const ValueKey('feedback_title_field')),
          'Ý kiến thử nghiệm huỷ',
        );
        await tester.enterText(
          find.byKey(const ValueKey('feedback_content_field')),
          'Nội dung ý kiến đủ dài để kiểm tra nút Huỷ.',
        );
        await tester.tap(find.byKey(const ValueKey('feedback_cancel_button')));
        await tester.pumpAndSettle();

        expect(find.text('Gửi ý kiến đóng góp'), findsNothing);
        expect(find.text('Ý kiến thử nghiệm huỷ'), findsNothing);

        await tester.tap(find.text('Gửi ý kiến'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const ValueKey('feedback_title_field')),
          'Đề nghị sửa đèn đường',
        );
        await tester.enterText(
          find.byKey(const ValueKey('feedback_content_field')),
          'Đoạn đầu ngõ bị tắt đèn 2 ngày nay.',
        );
        await tester.tap(find.byKey(const ValueKey('feedback_submit_button')));
        await tester.pumpAndSettle();

        expect(find.text('Đề nghị sửa đèn đường'), findsOneWidget);
      },
    );
  });

  group('Màn Lịch họp (MeetingsScreen) — Switch Ngày / Tháng', () {
    testWidgets(
      'Chuyển đổi Ngày/Tháng, hiển thị dấu chấm ngày có họp, chọn ngày và lướt ngang đổi tháng',
      (tester) async {
        final refDate = DateTime(2026, 11, 15, 10, 0);
        final deps = AppDependencies(seedReferenceTime: refDate);
        addTearDown(deps.dispose);

        await tester.pumpWidget(
          MaterialApp(
            home: MeetingsScreen(
              viewModel: deps.meetingsViewModel,
              currentUserId: 'res-citizen-1',
              initialDate: refDate,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Mặc định chế độ Ngày hiển thị danh sách cuộc họp
        expect(
          find.text('Giao ban công tác dân cư và rà soát nhân khẩu các thôn'),
          findsOneWidget,
        );

        // Chuyển sang chế độ Tháng
        await tester.tap(find.byKey(const ValueKey('meetings_view_switch')));
        await tester.pumpAndSettle();

        expect(find.text('Tháng 11 / 2026'), findsOneWidget);

        // Kiểm tra lịch tháng và danh sách nửa dưới chia đều 1 nửa chiều cao
        final calendarHeight = tester
            .getSize(find.byKey(const ValueKey('calendar_month_panel')))
            .height;
        final eventsHeight = tester
            .getSize(find.byKey(const ValueKey('calendar_events_panel')))
            .height;
        expect(calendarHeight, closeTo(eventsHeight, 16));

        // Ngày 15/11/2026 không có cuộc họp
        expect(find.text('Không có cuộc họp vào ngày này'), findsOneWidget);

        // Ngày 16/11/2026 (now + 1) có dấu chấm và hiển thị cuộc họp khi bấm vào
        expect(
          find.byKey(const ValueKey('calendar_dot_2026_11_16')),
          findsOneWidget,
        );
        await tester.tap(find.byKey(const ValueKey('calendar_day_2026_11_16')));
        await tester.pumpAndSettle();

        expect(find.text('Không có cuộc họp vào ngày này'), findsNothing);
        expect(
          find.text(
            'Họp triển khai tuyến đường nông thôn mới & giải phóng mặt bằng',
          ),
          findsOneWidget,
        );

        // Lướt ngang sang tháng tiếp theo
        await tester.drag(
          find.byKey(const ValueKey('calendar_month_pageview')),
          const Offset(-400, 0),
        );
        await tester.pumpAndSettle();

        expect(find.text('Tháng 12 / 2026'), findsOneWidget);
      },
    );
  });
}
