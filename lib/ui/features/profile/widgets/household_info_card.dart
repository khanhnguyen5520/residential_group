import 'package:flutter/material.dart';

import '../../../../domain/models/household_info.dart';

/// Thẻ hiển thị thông tin hộ gia đình và danh sách thành viên trong Profile.
class HouseholdInfoCard extends StatelessWidget {
  const HouseholdInfoCard({super.key, required this.household});

  final HouseholdInfo household;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.family_restroom_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Thông tin hộ gia đình',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _HouseholdRow(label: 'Mã hộ khẩu', value: household.householdCode),
            const SizedBox(height: 6),
            _HouseholdRow(label: 'Chủ hộ', value: household.headOfHousehold),
            const SizedBox(height: 6),
            _HouseholdRow(
              label: 'Khu vực',
              value: '${household.village}, Xã Tân Lập',
            ),
            const SizedBox(height: 6),
            _HouseholdRow(
              label: 'Số nhân khẩu',
              value: '${household.memberCount} thành viên',
            ),
            const Divider(height: 20),
            Text(
              'Danh sách thành viên',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            ...household.members.map((member) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: theme.colorScheme.primary.withValues(
                        alpha: 0.12,
                      ),
                      child: Icon(
                        Icons.person_outline,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        member.fullName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '${member.relationship} • ${member.birthYear}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _HouseholdRow extends StatelessWidget {
  const _HouseholdRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 112,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
