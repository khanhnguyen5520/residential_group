import 'package:flutter/material.dart';
import 'package:residential_group/domain/models/citizen_feedback.dart';
import 'package:residential_group/domain/models/resident_account.dart';

import '../view_models/feedback_view_model.dart';
import '../widgets/create_feedback_dialog.dart';
import '../widgets/feedback_card.dart';
import '../widgets/reply_feedback_dialog.dart';

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
              return FeedbackCard(
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
          builder: (_) => const CreateFeedbackDialog(),
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
      builder: (_) => ReplyFeedbackDialog(feedback: feedback),
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
