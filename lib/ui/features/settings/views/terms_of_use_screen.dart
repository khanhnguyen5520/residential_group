import 'package:flutter/material.dart';

/// Màn hình Điều khoản sử dụng ứng dụng Quản lý Dân cư Xã.
class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const sections = <({String title, String body})>[
      (
        title: '1. Mục đích và phạm vi sử dụng',
        body:
            'Ứng dụng Quản lý Dân cư Xã phục vụ công tác quản lý thông tin nhân khẩu, hộ gia đình, truyền tải thông báo, khảo sát và tiếp nhận ý kiến cư dân trên địa bàn xã.',
      ),
      (
        title: '2. Phân cấp tài khoản và trách nhiệm',
        body:
            '• Admin và Trưởng thôn có quyền ngang hàng trong việc thêm, chỉnh sửa, xoá hồ sơ cư dân và phản hồi ý kiến chính thức.\n'
            '• Phó thôn hỗ trợ theo dõi thông tin điều hành, lịch họp, khảo sát và tiếp nhận thông báo.\n'
            '• Cư dân có trách nhiệm cung cấp đúng thông tin CCCD, số điện thoại, địa chỉ và hộ gia đình.',
      ),
      (
        title: '3. Bảo mật thông tin cá nhân',
        body:
            'Số căn cước công dân, số điện thoại và thông tin hộ gia đình chỉ được sử dụng cho công tác quản lý hành chính và phục vụ cộng đồng dân cư tại địa phương.',
      ),
      (
        title: '4. Quy định về tài khoản và mật khẩu',
        body:
            'Người dùng có trách nhiệm bảo mật mật khẩu đăng nhập và đổi mật khẩu định kỳ. Khi xoá tài khoản, mọi thông tin đăng nhập của tài khoản đó sẽ được gỡ bỏ khỏi danh sách hoạt động.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Điều khoản sử dụng')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sections.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final section = sections[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    section.body,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
