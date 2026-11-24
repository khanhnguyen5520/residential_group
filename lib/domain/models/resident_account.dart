import 'household_info.dart';
import 'user_role.dart';

/// Hồ sơ tài khoản cư dân trong xã.
class ResidentAccount {
  const ResidentAccount({
    required this.id,
    required this.fullName,
    required this.role,
    required this.citizenId,
    required this.phoneNumber,
    required this.address,
    required this.village,
    required this.dateOfBirth,
    required this.gender,
    required this.household,
    required this.password,
    required this.avatarColorValue,
  });

  final String id;
  final String fullName;
  final UserRole role;
  final String citizenId;
  final String phoneNumber;
  final String address;
  final String village;
  final DateTime dateOfBirth;
  final String gender;
  final HouseholdInfo household;
  final String password;
  final int avatarColorValue;

  /// Lấy 2 ký tự viết tắt từ họ và tên để hiển thị trên avatar.
  String get initials {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return 'CD';
    }
    if (parts.length == 1) {
      final word = parts.first;
      return (word.length >= 2 ? word.substring(0, 2) : word).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  ResidentAccount copyWith({
    String? id,
    String? fullName,
    UserRole? role,
    String? citizenId,
    String? phoneNumber,
    String? address,
    String? village,
    DateTime? dateOfBirth,
    String? gender,
    HouseholdInfo? household,
    String? password,
    int? avatarColorValue,
  }) {
    return ResidentAccount(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      citizenId: citizenId ?? this.citizenId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      village: village ?? this.village,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      household: household ?? this.household,
      password: password ?? this.password,
      avatarColorValue: avatarColorValue ?? this.avatarColorValue,
    );
  }
}
