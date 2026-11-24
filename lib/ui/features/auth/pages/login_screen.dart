import 'package:flutter/material.dart';

import '../../../../domain/models/user_role.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/login_header_banner.dart';
import '../widgets/quick_role_card.dart';

/// Màn hình đăng nhập hỗ trợ nhập thông tin hoặc chọn nhanh theo 4 cấp tài khoản.
class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.viewModel,
    this.onAfterResetDemo,
  });

  final AuthViewModel viewModel;
  final VoidCallback? onAfterResetDemo;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    widget.viewModel.login(
      _identifierController.text,
      _passwordController.text,
    );
  }

  void _handleResetDemo() {
    widget.viewModel.resetDemoData();
    widget.onAfterResetDemo?.call();
    _identifierController.clear();
    _passwordController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã khôi phục dữ liệu mẫu ban đầu.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, _) {
            final errorMessage = widget.viewModel.errorMessage;
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const LoginHeaderBanner(),
                      const SizedBox(height: 24),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Đăng nhập hệ thống',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                TextFormField(
                                  key: const ValueKey('login_identifier_field'),
                                  controller: _identifierController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (_) =>
                                      widget.viewModel.clearError(),
                                  decoration: const InputDecoration(
                                    labelText: 'Số điện thoại hoặc số CCCD',
                                    hintText: 'Ví dụ: 0901000001',
                                    prefixIcon: Icon(Icons.person_outline),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Vui lòng nhập số điện thoại hoặc CCCD';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  key: const ValueKey('login_password_field'),
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => _submitLogin(),
                                  onChanged: (_) =>
                                      widget.viewModel.clearError(),
                                  decoration: InputDecoration(
                                    labelText: 'Mật khẩu',
                                    hintText: 'Mặc định: 123456',
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      tooltip: _obscurePassword
                                          ? 'Hiện mật khẩu'
                                          : 'Ẩn mật khẩu',
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Vui lòng nhập mật khẩu';
                                    }
                                    return null;
                                  },
                                ),
                                if (errorMessage != null) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: colorScheme.errorContainer,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          size: 20,
                                          color: colorScheme.onErrorContainer,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            errorMessage,
                                            style: TextStyle(
                                              color:
                                                  colorScheme.onErrorContainer,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 16),
                                FilledButton(
                                  key: const ValueKey('login_submit_button'),
                                  onPressed: _submitLogin,
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Đăng nhập',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'Đăng nhập nhanh theo vai trò',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...UserRole.values.map(
                        (role) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: QuickRoleCard(
                            role: role,
                            onTap: () => widget.viewModel.loginByRole(role),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextButton.icon(
                        key: const ValueKey('reset_demo_button'),
                        onPressed: _handleResetDemo,
                        icon: const Icon(Icons.restart_alt),
                        label: const Text('Khôi phục dữ liệu mẫu'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
