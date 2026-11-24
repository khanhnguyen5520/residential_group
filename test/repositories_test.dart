import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:residential_group/data/repositories/auth_repository.dart';
import 'package:residential_group/data/repositories/notification_repository.dart';
import 'package:residential_group/data/repositories/resident_repository.dart';
import 'package:residential_group/data/services/in_memory_commune_service.dart';
import 'package:residential_group/domain/models/household_info.dart';
import 'package:residential_group/domain/models/notification_filter.dart';
import 'package:residential_group/domain/models/resident_account.dart';
import 'package:residential_group/domain/models/user_role.dart';

void main() {
  group('Phân quyền và Quản lý cư dân (ResidentRepository)', () {
    late InMemoryCommuneService service;
    late ResidentRepository residentRepo;

    setUp(() {
      service = InMemoryCommuneService(
        seedReferenceTime: DateTime(2026, 11, 20, 14, 0),
      );
      residentRepo = ResidentRepository(service: service);
    });

    ResidentAccount buildSampleResident({
      String id = 'res-new-1',
      String citizenId = '036099000099',
      String phone = '0909999999',
    }) {
      return ResidentAccount(
        id: id,
        fullName: 'Trần Văn Mới',
        role: UserRole.resident,
        citizenId: citizenId,
        phoneNumber: phone,
        address: 'Số 88, Thôn Đông, Xã Tân Lập',
        village: 'Thôn Đông',
        dateOfBirth: DateTime(1994, 5, 10),
        gender: 'Nam',
        password: '123456',
        avatarColorValue: 0xFF0F6B5E,
        household: const HouseholdInfo(
          householdCode: 'HK-TL-0099',
          village: 'Thôn Đông',
          headOfHousehold: 'Trần Văn Mới',
          registeredAddress: 'Số 88, Thôn Đông, Xã Tân Lập',
          members: <HouseholdMember>[
            HouseholdMember(
              fullName: 'Trần Văn Mới',
              relationship: 'Chủ hộ',
              birthYear: 1994,
            ),
          ],
        ),
      );
    }

    test('Admin và Trưởng thôn đều có quyền quản lý cư dân ngang nhau', () {
      expect(UserRole.admin.canManageResidents, isTrue);
      expect(UserRole.villageHead.canManageResidents, isTrue);
      expect(UserRole.deputyHead.canManageResidents, isFalse);
      expect(UserRole.resident.canManageResidents, isFalse);
    });

    test('Phó thôn và Cư dân bị từ chối khi thêm, sửa, xoá cư dân', () {
      final newResident = buildSampleResident();
      final existing = residentRepo.getResidents().last;

      for (final role in [UserRole.deputyHead, UserRole.resident]) {
        expect(
          () =>
              residentRepo.addResident(actorRole: role, resident: newResident),
          throwsStateError,
        );
        expect(
          () => residentRepo.updateResident(
            actorRole: role,
            resident: existing.copyWith(fullName: 'Đổi tên'),
          ),
          throwsStateError,
        );
        expect(
          () => residentRepo.deleteResident(
            actorRole: role,
            actorId: 'other-id',
            residentId: existing.id,
          ),
          throwsStateError,
        );
      }
    });

    test(
      'Trưởng thôn có thể thêm, sửa, xoá cư dân và tìm kiếm hoạt động đúng',
      () {
        final initialCount = residentRepo.getResidents().length;
        final added = buildSampleResident();

        residentRepo.addResident(
          actorRole: UserRole.villageHead,
          resident: added,
        );
        expect(residentRepo.getResidents().length, initialCount + 1);
        expect(residentRepo.getResidents(query: 'Trần Văn Mới').length, 1);

        residentRepo.updateResident(
          actorRole: UserRole.villageHead,
          resident: added.copyWith(fullName: 'Trần Văn Đã Sửa'),
        );
        expect(residentRepo.getResidents(query: 'Trần Văn Đã Sửa').length, 1);

        residentRepo.deleteResident(
          actorRole: UserRole.villageHead,
          actorId: 'res-head-1',
          residentId: added.id,
        );
        expect(residentRepo.getResidents().length, initialCount);
      },
    );

    test(
      'Không cho phép tự xoá tài khoản đang đăng nhập trong danh sách cư dân',
      () {
        expect(
          () => residentRepo.deleteResident(
            actorRole: UserRole.admin,
            actorId: 'res-admin-1',
            residentId: 'res-admin-1',
          ),
          throwsStateError,
        );
      },
    );
  });

  group('Xác thực, Đổi mật khẩu và Xoá tài khoản (AuthRepository)', () {
    late InMemoryCommuneService service;
    late AuthRepository authRepo;

    setUp(() {
      service = InMemoryCommuneService(
        seedReferenceTime: DateTime(2026, 11, 20, 14, 0),
      );
      authRepo = AuthRepository(service: service);
    });

    test('Đăng nhập bằng SĐT hoặc CCCD và đổi mật khẩu thành công', () {
      final loggedIn = authRepo.login('0901000004', '123456');
      expect(loggedIn.role, UserRole.resident);

      authRepo.changePassword(
        currentPassword: '123456',
        newPassword: 'newpass123',
      );
      authRepo.logout();

      expect(
        () => authRepo.login('036195000004', '123456'),
        throwsArgumentError,
      );
      final relogin = authRepo.login('036195000004', 'newpass123');
      expect(relogin.id, loggedIn.id);
    });

    test('Xoá tài khoản hiện tại đăng xuất và không cho đăng nhập lại', () {
      authRepo.loginByRole(UserRole.resident);
      authRepo.deleteCurrentAccount(password: '123456');

      expect(authRepo.currentUser, isNull);
      expect(() => authRepo.login('0901000004', '123456'), throwsArgumentError);
    });
  });

  group('Bộ lọc thời gian & Sắp xếp thông báo (NotificationRepository)', () {
    late DateTime refNow;
    late InMemoryCommuneService service;
    late NotificationRepository notificationRepo;

    setUp(() {
      refNow = DateTime(2026, 11, 20, 14, 0);
      service = InMemoryCommuneService(seedReferenceTime: refNow);
      notificationRepo = NotificationRepository(service: service);
    });

    test('Lọc theo Hôm nay, 7 ngày qua, 30 ngày qua, Tuỳ chọn và Tất cả', () {
      final all = notificationRepo.getNotifications(
        filter: NotificationTimeFilter.all,
        sortOrder: NotificationSortOrder.newestFirst,
        referenceNow: refNow,
      );
      final today = notificationRepo.getNotifications(
        filter: NotificationTimeFilter.today,
        sortOrder: NotificationSortOrder.newestFirst,
        referenceNow: refNow,
      );
      final last7 = notificationRepo.getNotifications(
        filter: NotificationTimeFilter.last7Days,
        sortOrder: NotificationSortOrder.newestFirst,
        referenceNow: refNow,
      );
      final last30 = notificationRepo.getNotifications(
        filter: NotificationTimeFilter.last30Days,
        sortOrder: NotificationSortOrder.newestFirst,
        referenceNow: refNow,
      );
      final custom = notificationRepo.getNotifications(
        filter: NotificationTimeFilter.customRange,
        sortOrder: NotificationSortOrder.newestFirst,
        customRange: DateTimeRange(
          start: DateTime(2026, 11, 1),
          end: DateTime(2026, 11, 16),
        ),
        referenceNow: refNow,
      );

      expect(all.length, 7);
      expect(today.length, 2);
      expect(last7.length, 4);
      expect(last30.length, 6);
      expect(custom.length, 2);
    });

    test('Sắp xếp Mới nhất / Cũ nhất theo đúng mốc createdAt', () {
      final newest = notificationRepo.getNotifications(
        filter: NotificationTimeFilter.all,
        sortOrder: NotificationSortOrder.newestFirst,
        referenceNow: refNow,
      );
      final oldest = notificationRepo.getNotifications(
        filter: NotificationTimeFilter.all,
        sortOrder: NotificationSortOrder.oldestFirst,
        referenceNow: refNow,
      );

      for (var i = 0; i < newest.length - 1; i++) {
        expect(
          newest[i].createdAt.isAfter(newest[i + 1].createdAt) ||
              newest[i].createdAt.isAtSameMomentAs(newest[i + 1].createdAt),
          isTrue,
        );
        expect(
          oldest[i].createdAt.isBefore(oldest[i + 1].createdAt) ||
              oldest[i].createdAt.isAtSameMomentAs(oldest[i + 1].createdAt),
          isTrue,
        );
      }
      expect(newest.first.id, oldest.last.id);
    });
  });
}
