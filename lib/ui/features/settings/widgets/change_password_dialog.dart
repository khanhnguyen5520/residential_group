import 'package:flutter/material.dart';

import '../../auth/view_models/auth_view_model.dart';

/// Hộp thoại Đổi mật khẩu cho người dùng hiện tại.
class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key, required this.authViewModel});

  final AuthViewModel authViewModel;

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _serverError;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final error = widget.authViewModel.changePassword(
      currentPassword: _currentController.text,
      newPassword: _newController.text,
    );
    if (error != null) {
      setState(() {
        _serverError = error;
      });
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Đổi mật khẩu'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const ValueKey('change_pw_current'),
                controller: _currentController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu hiện tại',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu hiện tại';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('change_pw_new'),
                controller: _newController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu mới',
                  hintText: 'Tối thiểu 6 ký tự',
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 6) {
                    return 'Mật khẩu mới phải có ít nhất 6 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('change_pw_confirm'),
                controller: _confirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nhập lại mật khẩu mới',
                ),
                validator: (value) {
                  if (value != _newController.text) {
                    return 'Mật khẩu xác nhận không khớp';
                  }
                  return null;
                },
              ),
              if (_serverError != null) ...[
                const SizedBox(height: 10),
                Text(
                  _serverError!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Huỷ'),
        ),
        FilledButton(
          key: const ValueKey('change_pw_submit'),
          onPressed: _submit,
          child: const Text('Cập nhật'),
        ),
      ],
    );
  }
}
