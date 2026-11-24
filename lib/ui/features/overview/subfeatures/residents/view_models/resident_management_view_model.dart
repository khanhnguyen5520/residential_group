import 'package:flutter/foundation.dart';
import 'package:residential_group/data/repositories/resident_repository.dart';
import 'package:residential_group/domain/models/resident_account.dart';
import 'package:residential_group/domain/models/user_role.dart';
import 'package:residential_group/ui/features/auth/view_models/auth_view_model.dart';

/// ViewModel quản lý danh sách, tìm kiếm và thao tác Thêm/Sửa/Xoá cư dân.
class ResidentManagementViewModel extends ChangeNotifier {
  ResidentManagementViewModel({
    required this._residentRepository,
    required this._authViewModel,
    this.onResidentsChanged,
  }) {
    load();
  }

  final ResidentRepository _residentRepository;
  final AuthViewModel _authViewModel;
  final VoidCallback? onResidentsChanged;

  List<ResidentAccount> _residents = const <ResidentAccount>[];
  String _query = '';
  UserRole? _roleFilter;

  List<ResidentAccount> get residents => _residents;
  String get query => _query;
  UserRole? get roleFilter => _roleFilter;

  int get totalResidents => _residentRepository.getResidents().length;

  int get totalHouseholds => _residentRepository
      .getResidents()
      .map((item) => item.household.householdCode)
      .toSet()
      .length;

  void load() {
    _residents = _residentRepository.getResidents(
      query: _query,
      roleFilter: _roleFilter,
    );
    notifyListeners();
  }

  void setQuery(String value) {
    _query = value;
    load();
  }

  void setRoleFilter(UserRole? role) {
    _roleFilter = role;
    load();
  }

  String? addResident(ResidentAccount resident) {
    final actor = _authViewModel.currentUser;
    if (actor == null) {
      return 'Phiên đăng nhập không hợp lệ.';
    }
    try {
      _residentRepository.addResident(
        actorRole: actor.role,
        resident: resident,
      );
      load();
      onResidentsChanged?.call();
      return null;
    } on Object catch (error) {
      return _formatError(error);
    }
  }

  String? updateResident(ResidentAccount resident) {
    final actor = _authViewModel.currentUser;
    if (actor == null) {
      return 'Phiên đăng nhập không hợp lệ.';
    }
    try {
      _residentRepository.updateResident(
        actorRole: actor.role,
        resident: resident,
      );
      if (resident.id == actor.id) {
        _authViewModel.refreshCurrentUser();
      }
      load();
      onResidentsChanged?.call();
      return null;
    } on Object catch (error) {
      return _formatError(error);
    }
  }

  String? deleteResident(String residentId) {
    final actor = _authViewModel.currentUser;
    if (actor == null) {
      return 'Phiên đăng nhập không hợp lệ.';
    }
    try {
      _residentRepository.deleteResident(
        actorRole: actor.role,
        actorId: actor.id,
        residentId: residentId,
      );
      load();
      onResidentsChanged?.call();
      return null;
    } on Object catch (error) {
      return _formatError(error);
    }
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
