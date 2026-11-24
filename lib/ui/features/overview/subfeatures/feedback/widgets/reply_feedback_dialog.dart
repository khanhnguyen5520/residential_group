import 'package:flutter/material.dart';
import 'package:residential_group/domain/models/citizen_feedback.dart';

/// Hộp thoại cập nhật trạng thái và phản hồi ý kiến dành cho Admin / Trưởng thôn.
class ReplyFeedbackDialog extends StatefulWidget {
  const ReplyFeedbackDialog({super.key, required this.feedback});

  final CitizenFeedback feedback;

  @override
  State<ReplyFeedbackDialog> createState() => _ReplyFeedbackDialogState();
}

class _ReplyFeedbackDialogState extends State<ReplyFeedbackDialog> {
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
