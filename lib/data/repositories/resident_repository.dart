import '../../domain/models/app_notification.dart';
import '../../domain/models/resident_account.dart';
import '../../domain/models/user_role.dart';
import '../services/in_memory_commune_service.dart';

/// Repository quản lý danh sách cư dân và kiểm tra quyền Admin / Trưởng thôn.
class ResidentRepository {
  ResidentRepository({required this._service});

  final InMemoryCommuneService _service;

  List<ResidentAccount> getResidents({
    String query = '',
    UserRole? roleFilter,
  }) {
    final normalized = query.trim().toLowerCase();
    return _service.residents.where((resident) {
      if (roleFilter != null && resident.role != roleFilter) {
        return false;
      }
      if (normalized.isEmpty) {
        return true;
      }
      return resident.fullName.toLowerCase().contains(normalized) ||
          resident.citizenId.toLowerCase().contains(normalized) ||
          resident.phoneNumber.toLowerCase().contains(normalized) ||
          resident.village.toLowerCase().contains(normalized) ||
          resident.household.householdCode.toLowerCase().contains(normalized);
    }).toList();
  }

  void addResident({
    required UserRole actorRole,
    required ResidentAccount resident,
  }) {
    _assertCanManage(actorRole);
    _validateUniqueness(resident);

    _service.addResident(resident);
    _service.addNotification(
      AppNotification(
        id: 'noti-res-add-${DateTime.now().microsecondsSinceEpoch}',
        title: 'Thêm hồ sơ cư dân mới: ${resident.fullName}',
        body:
            'Cư dân ${resident.fullName} (${resident.role.displayName}) đã được bổ sung vào danh sách ${resident.village}, mã hộ ${resident.household.householdCode}.',
        category: NotificationCategory.resident,
        createdAt: DateTime.now(),
      ),
    );
  }

  void updateResident({
    required UserRole actorRole,
    required ResidentAccount resident,
  }) {
    _assertCanManage(actorRole);
    _validateUniqueness(resident, excludeId: resident.id);
    _service.updateResident(resident);
  }

  void deleteResident({
    required UserRole actorRole,
    required String actorId,
    required String residentId,
  }) {
    _assertCanManage(actorRole);
    if (actorId == residentId) {
      throw StateError(
        'Không thể xoá tài khoản đang đăng nhập tại đây. '
        'Vui lòng dùng mục Xoá tài khoản trong Cài đặt.',
      );
    }

    _service.removeResident(residentId);
  }

  void _assertCanManage(UserRole actorRole) {
    if (!actorRole.canManageResidents) {
      throw StateError(
        'Tài khoản cấp ${actorRole.displayName} không có quyền quản lý cư dân. '
        'Chỉ Admin hoặc Trưởng thôn mới được phép thực hiện thao tác này.',
      );
    }
  }

  void _validateUniqueness(ResidentAccount candidate, {String? excludeId}) {
    for (final existing in _service.residents) {
      if (excludeId != null && existing.id == excludeId) {
        continue;
      }
      if (existing.citizenId == candidate.citizenId.trim()) {
        throw ArgumentError('Số CCCD "${candidate.citizenId}" đã tồn tại.');
      }
      if (existing.phoneNumber == candidate.phoneNumber.trim()) {
        throw ArgumentError(
          'Số điện thoại "${candidate.phoneNumber}" đã tồn tại.',
        );
      }
    }
  }
}
