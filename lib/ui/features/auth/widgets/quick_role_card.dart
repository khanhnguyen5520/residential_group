import 'package:flutter/material.dart';

import '../../../../domain/models/user_role.dart';
import '../../../core/widgets/role_badge.dart';

/// Thẻ đăng nhập nhanh 1 chạm theo từng cấp tài khoản mẫu.
class QuickRoleCard extends StatelessWidget {
  const QuickRoleCard({super.key, required this.role, required this.onTap});

  final UserRole role;
  final VoidCallback onTap;

  String get _samplePhone => switch (role) {
    UserRole.admin => '0901000001',
    UserRole.villageHead => '0901000002',
    UserRole.deputyHead => '0901000003',
    UserRole.resident => '0901000004',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        key: ValueKey('quick_login_${role.name}'),
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        RoleBadge(role: role, compact: true),
                        const SizedBox(width: 8),
                        Text(
                          'SĐT: $_samplePhone',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(role.subtitle, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
