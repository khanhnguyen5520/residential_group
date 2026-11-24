import '../../domain/models/resident_account.dart';
import '../../domain/models/user_role.dart';
import '../services/in_memory_commune_service.dart';

/// Repository quản lý phiên đăng nhập, phân cấp tài khoản, mật khẩu và hồ sơ cá nhân.
class AuthRepository {
  AuthRepository({required this._service});

  final InMemoryCommuneService _service;

  ResidentAccount? get currentUser => _service.currentUser;

  /// Đăng nhập bằng Số điện thoại hoặc Số CCCD cùng mật khẩu.
  ResidentAccount login(String identifier, String password) {
    final normalizedId = identifier.trim();
    if (normalizedId.isEmpty || password.isEmpty) {
      throw ArgumentError(
        'Vui lòng nhập đầy đủ số điện thoại/CCCD và mật khẩu.',
      );
    }

    for (final resident in _service.residents) {
      final matchesIdentifier =
          resident.phoneNumber == normalizedId ||
          resident.citizenId == normalizedId;
      if (matchesIdentifier) {
        if (resident.password != password) {
          throw ArgumentError('Mật khẩu không chính xác.');
        }
        _service.setCurrentUserId(resident.id);
        return resident;
      }
    }

    throw ArgumentError(
      'Không tìm thấy tài khoản khớp với số điện thoại/CCCD.',
    );
  }

  /// Đăng nhập nhanh theo cấp tài khoản mẫu để trải nghiệm phân quyền.
  ResidentAccount loginByRole(UserRole role) {
    for (final resident in _service.residents) {
      if (resident.role == role) {
        _service.setCurrentUserId(resident.id);
        return resident;
      }
    }
    throw StateError(
      'Không còn tài khoản mẫu cho vai trò ${role.displayName}. '
      'Hãy bấm "Khôi phục dữ liệu mẫu" để khôi phục.',
    );
  }

  void logout() {
    _service.setCurrentUserId(null);
  }

  void changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    final user = currentUser;
    if (user == null) {
      throw StateError('Phiên đăng nhập đã hết hạn.');
    }
    if (user.password != currentPassword) {
      throw ArgumentError('Mật khẩu hiện tại không chính xác.');
    }
    if (newPassword.trim().length < 6) {
      throw ArgumentError('Mật khẩu mới phải có ít nhất 6 ký tự.');
    }
    if (newPassword == currentPassword) {
      throw ArgumentError('Mật khẩu mới không được trùng mật khẩu hiện tại.');
    }

    _service.updateResident(user.copyWith(password: newPassword));
  }

  String? verifyCurrentPassword(String password) {
    final user = currentUser;
    if (user == null) {
      return 'Phiên đăng nhập đã hết hạn.';
    }
    if (password.isEmpty) {
      return 'Vui lòng nhập mật khẩu xác nhận.';
    }
    if (user.password != password) {
      return 'Mật khẩu xác nhận không chính xác.';
    }
    return null;
  }

  void deleteCurrentAccount({required String password}) {
    final user = currentUser;
    if (user == null) {
      throw StateError('Phiên đăng nhập đã hết hạn.');
    }
    if (user.password != password) {
      throw ArgumentError('Mật khẩu xác nhận không chính xác.');
    }

    _service.removeResident(user.id);
  }

  ResidentAccount updateCurrentProfile(ResidentAccount updated) {
    final user = currentUser;
    if (user == null) {
      throw StateError('Phiên đăng nhập đã hết hạn.');
    }

    final normalizedCitizenId = updated.citizenId.trim();
    final normalizedPhone = updated.phoneNumber.trim();
    for (final other in _service.residents) {
      if (other.id == user.id) {
        continue;
      }
      if (other.citizenId == normalizedCitizenId) {
        throw ArgumentError('Số CCCD này đã được đăng ký cho cư dân khác.');
      }
      if (other.phoneNumber == normalizedPhone) {
        throw ArgumentError(
          'Số điện thoại này đã được đăng ký cho cư dân khác.',
        );
      }
    }

    final merged = updated.copyWith(
      id: user.id,
      role: user.role,
      password: user.password,
      citizenId: normalizedCitizenId,
      phoneNumber: normalizedPhone,
    );
    _service.updateResident(merged);
    return merged;
  }

  void resetDemoData() {
    _service.resetDemoData();
  }
}
