import 'package:flutter/material.dart';

import '../../../domain/models/resident_account.dart';
import '../../../domain/models/user_role.dart';

/// Avatar hình tròn hiển thị chữ viết tắt tên người dùng kèm viền phân cấp vai trò.
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.account, this.radius = 28});

  final ResidentAccount account;
  final double radius;

  Color _borderColor(UserRole role) => switch (role) {
    UserRole.admin => const Color(0xFFB3261E),
    UserRole.villageHead => const Color(0xFF0F6B5E),
    UserRole.deputyHead => const Color(0xFFC46D12),
    UserRole.resident => const Color(0xFF1D6295),
  };

  @override
  Widget build(BuildContext context) {
    final fillColor = Color(account.avatarColorValue);
    final ringColor = _borderColor(account.role);

    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ringColor.withValues(alpha: 0.75), width: 2),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: fillColor,
        child: Text(
          account.initials,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: radius * 0.62,
          ),
        ),
      ),
    );
  }
}
