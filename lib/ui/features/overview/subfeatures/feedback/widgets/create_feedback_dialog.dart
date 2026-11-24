import 'package:flutter/material.dart';

/// Hộp thoại gửi ý kiến đóng góp mới từ cư dân.
class CreateFeedbackDialog extends StatefulWidget {
  const CreateFeedbackDialog({super.key});

  @override
  State<CreateFeedbackDialog> createState() => _CreateFeedbackDialogState();
}

class _CreateFeedbackDialogState extends State<CreateFeedbackDialog> {
  static const List<String> _categories = <String>[
    'Hạ tầng & Môi trường',
    'An toàn giao thông',
    'An ninh trật tự',
    'Chiếu sáng công cộng',
    'Thủ tục hành chính',
  ];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedCategory = _categories.first;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    Navigator.of(context).pop((
      title: _titleController.text,
      content: _contentController.text,
      category: _selectedCategory,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Gửi ý kiến đóng góp'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Chủ đề', style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _categories.map((category) {
                  return ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('feedback_title_field'),
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Tiêu đề ý kiến'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('feedback_content_field'),
                controller: _contentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Nội dung chi tiết',
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 10) {
                    return 'Vui lòng mô tả ít nhất 10 ký tự';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          key: const ValueKey('feedback_cancel_button'),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Huỷ'),
        ),
        FilledButton(
          key: const ValueKey('feedback_submit_button'),
          onPressed: _submit,
          child: const Text('Gửi'),
        ),
      ],
    );
  }
}
