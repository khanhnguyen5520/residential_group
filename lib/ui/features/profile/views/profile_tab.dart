import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../domain/models/resident_account.dart';
import '../../../core/widgets/role_badge.dart';
import '../../../core/widgets/user_avatar.dart';
import '../view_models/profile_view_model.dart';
import 'edit_profile_screen.dart';

/// Tab 4 — Màn Profile: trên cùng là tên người tài khoản kèm icon chỉnh sửa,
/// bên dưới là căn cước công dân, số điện thoại, địa chỉ, thông tin hộ gia đình.
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key, required this.viewModel});

  final ProfileViewModel viewModel;

  Future<void> _openEdit(BuildContext context, ResidentAccount account) async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) =>
            EditProfileScreen(viewModel: viewModel, account: account),
      ),
    );
    if (updated == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã cập nhật thông tin cá nhân.')),
      );
    }
  }

  void _copyCitizenId(BuildContext context, String citizenId) {
    Clipboard.setData(ClipboardData(text: citizenId));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Đã sao chép số CCCD: $citizenId')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          final user = viewModel.currentUser;
          if (user == null) {
            return const SizedBox.shrink();
          }

          final theme = Theme.of(context);
          final household = user.household;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      UserAvatar(account: user, radius: 30),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    user.fullName,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  key: const ValueKey('edit_profile_button'),
                                  tooltip: 'Chỉnh sửa thông tin',
                                  onPressed: () => _openEdit(context, user),
                                  icon: const Icon(Icons.edit_outlined),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            RoleBadge(role: user.role),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.credit_card_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      title: const Text('Căn cước công dân'),
                      subtitle: Text(
                        user.citizenId,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: IconButton(
                        tooltip: 'Sao chép số CCCD',
                        onPressed: () =>
                            _copyCitizenId(context, user.citizenId),
                        icon: const Icon(Icons.copy_outlined, size: 20),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        Icons.phone_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      title: const Text('Số điện thoại'),
                      subtitle: Text(
                        user.phoneNumber,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        Icons.location_on_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      title: const Text('Địa chỉ'),
                      subtitle: Text(
                        user.address,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Card(
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
                      _HouseholdRow(
                        label: 'Mã hộ khẩu',
                        value: household.householdCode,
                      ),
                      const SizedBox(height: 6),
                      _HouseholdRow(
                        label: 'Chủ hộ',
                        value: household.headOfHousehold,
                      ),
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
                                backgroundColor: theme.colorScheme.primary
                                    .withValues(alpha: 0.12),
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
              ),
            ],
          );
        },
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
