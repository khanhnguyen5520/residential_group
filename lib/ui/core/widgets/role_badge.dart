import 'package:flutter/material.dart';

import '../../../domain/models/user_role.dart';

/// Huy hiệu phân biệt 4 cấp tài khoản (Admin, Trưởng thôn, Phó thôn, Cư dân).
class RoleBadge extends StatelessWidget {
  const RoleBadge({super.key, required this.role, this.compact = false});

  final UserRole role;
  final bool compact;

  Color get _baseColor => switch (role) {
    UserRole.admin => const Color(0xFFB3261E),
    UserRole.villageHead => const Color(0xFF0F6B5E),
    UserRole.deputyHead => const Color(0xFFC46D12),
    UserRole.resident => const Color(0xFF1D6295),
  };

  IconData get _icon => switch (role) {
    UserRole.admin => Icons.admin_panel_settings_outlined,
    UserRole.villageHead => Icons.verified_user_outlined,
    UserRole.deputyHead => Icons.badge_outlined,
    UserRole.resident => Icons.person_outline,
  };

  @override
  Widget build(BuildContext context) {
    final color = _baseColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fgColor = isDark ? Color.lerp(color, Colors.white, 0.4)! : color;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.24 : 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: compact ? 13 : 15, color: fgColor),
          const SizedBox(width: 4),
          Text(
            role.displayName,
            style: TextStyle(
              color: fgColor,
              fontSize: compact ? 11.5 : 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
