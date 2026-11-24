import 'package:flutter/material.dart';

import '../../auth/view_models/auth_view_model.dart';
import '../view_models/settings_view_model.dart';
import '../widgets/change_password_dialog.dart';
import '../widgets/delete_account_dialog.dart';
import 'terms_of_use_screen.dart';

/// Tab 3 — Màn Cài đặt: danh sách các chức năng Chế độ sáng, Thông tin ứng dụng,
/// Điều khoản sử dụng, Đổi mật khẩu, Đăng xuất, Xoá tài khoản.
class SettingsTab extends StatelessWidget {
  const SettingsTab({
    super.key,
    required this.settingsViewModel,
    required this.authViewModel,
  });

  final SettingsViewModel settingsViewModel;
  final AuthViewModel authViewModel;

  Future<void> _showAppInfoDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thông tin ứng dụng'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quản lý Dân cư Xã',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              SizedBox(height: 6),
              Text('Phiên bản: 1.0.0'),
              SizedBox(height: 4),
              Text('Đơn vị triển khai: UBND Xã Tân Lập'),
              SizedBox(height: 4),
              Text('Hỗ trợ kỹ thuật: vanphong@tanlap.gov.vn'),
              SizedBox(height: 10),
              Text(
                'Ứng dụng hỗ trợ phân cấp Admin, Trưởng thôn, Phó thôn và Cư dân '
                'trong công tác quản lý nhân khẩu, thông báo và tương tác cộng đồng.',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    final changed = await showDialog<bool>(
      context: context,
      builder: (_) => ChangePasswordDialog(authViewModel: authViewModel),
    );
    if (changed == true && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đổi mật khẩu thành công.')));
    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Đăng xuất'),
          content: const Text(
            'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản hiện tại?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Huỷ'),
            ),
            FilledButton(
              key: const ValueKey('confirm_logout_button'),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      authViewModel.logout();
    }
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmedPassword = await showDialog<String>(
      context: context,
      builder: (_) => DeleteAccountDialog(authViewModel: authViewModel),
    );

    if (confirmedPassword == null) {
      return;
    }

    final error = authViewModel.deleteAccount(password: confirmedPassword);
    if (error == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Tài khoản của bạn đã được xoá.')),
      );
    } else {
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;
    final bottomPadding = MediaQuery.paddingOf(context).bottom + 40;

    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt')),
      body: ListenableBuilder(
        listenable: settingsViewModel,
        builder: (context, _) {
          return ListView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding),
            children: [
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      key: const ValueKey('settings_light_mode_switch'),
                      secondary: const Icon(Icons.light_mode_outlined),
                      title: const Text('Chế độ sáng'),
                      subtitle: Text(
                        settingsViewModel.isLightMode
                            ? 'Đang bật giao diện sáng'
                            : 'Đang dùng giao diện tối',
                      ),
                      value: settingsViewModel.isLightMode,
                      onChanged: settingsViewModel.setLightMode,
                    ),
                    const Divider(height: 1),
                    ListTile(
                      key: const ValueKey('settings_app_info_tile'),
                      leading: const Icon(Icons.info_outline),
                      title: const Text('Thông tin ứng dụng'),
                      subtitle: const Text('Phiên bản 1.0.0 • UBND Xã Tân Lập'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showAppInfoDialog(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      key: const ValueKey('settings_terms_tile'),
                      leading: const Icon(Icons.description_outlined),
                      title: const Text('Điều khoản sử dụng'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const TermsOfUseScreen(),
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      key: const ValueKey('settings_change_password_tile'),
                      leading: const Icon(Icons.lock_reset_outlined),
                      title: const Text('Đổi mật khẩu'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showChangePasswordDialog(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      key: const ValueKey('settings_logout_tile'),
                      leading: const Icon(Icons.logout_rounded),
                      title: const Text('Đăng xuất'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _confirmLogout(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      key: const ValueKey('settings_delete_account_tile'),
                      leading: Icon(
                        Icons.delete_forever_outlined,
                        color: errorColor,
                      ),
                      title: Text(
                        'Xoá tài khoản',
                        style: TextStyle(
                          color: errorColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Icon(Icons.chevron_right, color: errorColor),
                      onTap: () => _confirmDeleteAccount(context),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
