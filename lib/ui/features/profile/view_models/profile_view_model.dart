import 'package:flutter/foundation.dart';

import '../../../../data/repositories/auth_repository.dart';
import '../../../../domain/models/resident_account.dart';
import '../../auth/view_models/auth_view_model.dart';

/// ViewModel quản lý xem và chỉnh sửa hồ sơ tài khoản cá nhân & hộ gia đình.
class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({
    required this._authRepository,
    required this._authViewModel,
  });

  final AuthRepository _authRepository;
  final AuthViewModel _authViewModel;

  ResidentAccount? get currentUser => _authViewModel.currentUser;

  String? updateProfile(ResidentAccount updated) {
    try {
      _authRepository.updateCurrentProfile(updated);
      _authViewModel.refreshCurrentUser();
      notifyListeners();
      return null;
    } on Object catch (error) {
      if (error is ArgumentError) {
        return error.message?.toString() ?? error.toString();
      }
      if (error is StateError) {
        return error.message;
      }
      return error.toString();
    }
  }
}
