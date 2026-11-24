import 'package:flutter/material.dart';

import '../../../../domain/models/resident_account.dart';
import '../../../../domain/models/user_role.dart';
import '../../../core/widgets/role_badge.dart';
import '../../../core/widgets/user_avatar.dart';

/// Thẻ hiển thị thông tin chủ tài khoản ở trên cùng màn Tổng quan.
class AccountHeaderCard extends StatelessWidget {
  const AccountHeaderCard({super.key, required this.currentUser});

  final ResidentAccount currentUser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            UserAvatar(account: currentUser, radius: 30),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentUser.fullName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      RoleBadge(role: currentUser.role),
                      Text(
                        '${currentUser.village} • Xã Tân Lập',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  if (currentUser.role == UserRole.villageHead) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Quyền điều hành ngang hàng Admin',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
