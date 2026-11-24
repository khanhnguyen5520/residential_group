import 'package:flutter/material.dart';

import '../../auth/view_models/auth_view_model.dart';

/// Hộp thoại xác nhận mật khẩu khi người dùng chọn Xoá tài khoản.
class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key, required this.authViewModel});

  final AuthViewModel authViewModel;

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final _passwordController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _confirm() {
    final password = _passwordController.text;
    final error = widget.authViewModel.verifyCurrentPassword(password);
    if (error != null) {
      setState(() {
        _errorText = error;
      });
      return;
    }
    Navigator.of(context).pop(password);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Xoá tài khoản'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hành động này sẽ xoá vĩnh viễn tài khoản của bạn khỏi hệ thống xã. '
              'Vui lòng nhập mật khẩu để xác nhận.',
            ),
            const SizedBox(height: 12),
            TextField(
              key: const ValueKey('delete_account_password_field'),
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mật khẩu xác nhận',
                errorText: _errorText,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Huỷ'),
        ),
        FilledButton(
          key: const ValueKey('confirm_delete_account_button'),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: _confirm,
          child: const Text('Xoá tài khoản'),
        ),
      ],
    );
  }
}
