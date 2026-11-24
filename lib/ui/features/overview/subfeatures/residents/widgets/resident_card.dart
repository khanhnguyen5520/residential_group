import 'package:flutter/material.dart';
import 'package:residential_group/domain/models/resident_account.dart';
import 'package:residential_group/ui/core/widgets/role_badge.dart';
import 'package:residential_group/ui/core/widgets/user_avatar.dart';

/// Thẻ hiển thị thông tin một cư dân kèm nút Sửa / Xoá.
class ResidentCard extends StatelessWidget {
  const ResidentCard({
    super.key,
    required this.resident,
    required this.isCurrentUser,
    required this.onEdit,
    required this.onDelete,
  });

  final ResidentAccount resident;
  final bool isCurrentUser;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UserAvatar(account: resident, radius: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            resident.fullName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (isCurrentUser)
                            Text(
                              '(Bạn)',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      RoleBadge(role: resident.role, compact: true),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'CCCD: ${resident.citizenId} • SĐT: ${resident.phoneNumber}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Mã hộ: ${resident.household.householdCode} • ${resident.address}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Divider(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  key: ValueKey('edit_resident_${resident.id}'),
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Sửa'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  key: ValueKey('delete_resident_${resident.id}'),
                  onPressed: onDelete,
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                  ),
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Xoá'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
