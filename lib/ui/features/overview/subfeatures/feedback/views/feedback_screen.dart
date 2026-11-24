import 'package:flutter/material.dart';
import 'package:residential_group/domain/models/citizen_feedback.dart';
import 'package:residential_group/domain/models/resident_account.dart';
import 'package:residential_group/ui/core/utils/date_formatter.dart';

import '../view_models/feedback_view_model.dart';

/// Màn hình Ý kiến: xem danh sách phản ánh, gửi ý kiến mới và phản hồi (Admin/Trưởng thôn).
class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({
    super.key,
    required this.viewModel,
    required this.currentUser,
  });

  final FeedbackViewModel viewModel;
  final ResidentAccount currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ý kiến')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateFeedbackDialog(context),
        icon: const Icon(Icons.add_comment_outlined),
        label: const Text('Gửi ý kiến'),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          final items = viewModel.feedbacks;
          if (items.isEmpty) {
            return const Center(child: Text('Chưa có ý kiến đóng góp nào.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return _FeedbackCard(
                feedback: item,
                canReply: currentUser.role.canManageResidents,
                onReplyTap: () => _showReplyDialog(context, item),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showCreateFeedbackDialog(BuildContext context) async {
    final result =
        await showDialog<({String title, String content, String category})>(
          context: context,
          builder: (_) => const _CreateFeedbackDialog(),
        );

    if (result != null && context.mounted) {
      viewModel.submitFeedback(
        title: result.title,
        content: result.content,
        category: result.category,
        authorId: currentUser.id,
        authorName: currentUser.fullName,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã gửi ý kiến tới ban quản lý xã.')),
      );
    }
  }

  Future<void> _showReplyDialog(
    BuildContext context,
    CitizenFeedback feedback,
  ) async {
    final result = await showDialog<({FeedbackStatus status, String reply})>(
      context: context,
      builder: (_) => _ReplyFeedbackDialog(feedback: feedback),
    );

    if (result != null && context.mounted) {
      final error = viewModel.replyFeedback(
        actorRole: currentUser.role,
        feedbackId: feedback.id,
        status: result.status,
        reply: result.reply,
      );
      if (error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }
}

class _CreateFeedbackDialog extends StatefulWidget {
  const _CreateFeedbackDialog();

  @override
  State<_CreateFeedbackDialog> createState() => _CreateFeedbackDialogState();
}

class _CreateFeedbackDialogState extends State<_CreateFeedbackDialog> {
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

class _ReplyFeedbackDialog extends StatefulWidget {
  const _ReplyFeedbackDialog({required this.feedback});

  final CitizenFeedback feedback;

  @override
  State<_ReplyFeedbackDialog> createState() => _ReplyFeedbackDialogState();
}

class _ReplyFeedbackDialogState extends State<_ReplyFeedbackDialog> {
  late final TextEditingController _replyController;
  late FeedbackStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _replyController = TextEditingController(
      text: widget.feedback.officialReply ?? '',
    );
    _selectedStatus = widget.feedback.status;
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cập nhật & Phản hồi ý kiến'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.feedback.title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              'Trạng thái xử lý',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: FeedbackStatus.values.map((status) {
                return ChoiceChip(
                  label: Text(status.displayName),
                  selected: _selectedStatus == status,
                  onSelected: (_) {
                    setState(() {
                      _selectedStatus = status;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _replyController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Nội dung phản hồi chính thức',
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
          onPressed: () => Navigator.of(
            context,
          ).pop((status: _selectedStatus, reply: _replyController.text)),
          child: const Text('Lưu phản hồi'),
        ),
      ],
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({
    required this.feedback,
    required this.canReply,
    required this.onReplyTap,
  });

  final CitizenFeedback feedback;
  final bool canReply;
  final VoidCallback onReplyTap;

  Color _statusColor(FeedbackStatus status) => switch (status) {
    FeedbackStatus.pending => const Color(0xFFC46D12),
    FeedbackStatus.inProgress => const Color(0xFF1D6295),
    FeedbackStatus.resolved => const Color(0xFF0F6B5E),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(feedback.status);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    feedback.category,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    feedback.status.displayName,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              feedback.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(feedback.content, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 10),
            Text(
              'Gửi bởi: ${feedback.authorName} • ${DateFormatter.formatDateTime(feedback.createdAt)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (feedback.officialReply != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phản hồi từ Ban quản lý:',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      feedback.officialReply!,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
            if (canReply) ...[
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: onReplyTap,
                  icon: const Icon(Icons.reply_outlined, size: 18),
                  label: const Text('Phản hồi / Cập nhật'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
