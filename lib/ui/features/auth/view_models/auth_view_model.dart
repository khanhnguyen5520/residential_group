import 'package:flutter/foundation.dart';

import '../../../../data/repositories/auth_repository.dart';
import '../../../../domain/models/resident_account.dart';
import '../../../../domain/models/user_role.dart';

/// ViewModel quản lý trạng thái đăng nhập, phân cấp tài khoản và bảo mật tài khoản.
class AuthViewModel extends ChangeNotifier {
  AuthViewModel({required this._authRepository});

  final AuthRepository _authRepository;

  String? _errorMessage;

  ResidentAccount? get currentUser => _authRepository.currentUser;
  bool get isAuthenticated => currentUser != null;
  String? get errorMessage => _errorMessage;

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  bool login(String identifier, String password) {
    try {
      _authRepository.login(identifier, password);
      _errorMessage = null;
      notifyListeners();
      return true;
    } on Object catch (error) {
      _errorMessage = _formatError(error);
      notifyListeners();
      return false;
    }
  }

  bool loginByRole(UserRole role) {
    try {
      _authRepository.loginByRole(role);
      _errorMessage = null;
      notifyListeners();
      return true;
    } on Object catch (error) {
      _errorMessage = _formatError(error);
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _authRepository.logout();
    _errorMessage = null;
    notifyListeners();
  }

  /// Trả về `null` nếu thành công, hoặc thông báo lỗi nếu thất bại.
  String? changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    try {
      _authRepository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      notifyListeners();
      return null;
    } on Object catch (error) {
      return _formatError(error);
    }
  }

  String? verifyCurrentPassword(String password) {
    return _authRepository.verifyCurrentPassword(password);
  }

  /// Trả về `null` nếu xoá tài khoản thành công, hoặc thông báo lỗi nếu sai mật khẩu.
  String? deleteAccount({required String password}) {
    try {
      _authRepository.deleteCurrentAccount(password: password);
      _errorMessage = null;
      notifyListeners();
      return null;
    } on Object catch (error) {
      return _formatError(error);
    }
  }

  void refreshCurrentUser() {
    notifyListeners();
  }

  void resetDemoData() {
    _authRepository.resetDemoData();
    _errorMessage = null;
    notifyListeners();
  }

  static String _formatError(Object error) {
    if (error is ArgumentError) {
      return error.message?.toString() ?? error.toString();
    }
    if (error is StateError) {
      return error.message;
    }
    return error.toString();
  }
}
