import 'package:flutter/material.dart';
import 'package:residential_group/domain/models/resident_account.dart';
import 'package:residential_group/domain/models/user_role.dart';

import '../view_models/resident_management_view_model.dart';
import '../widgets/resident_card.dart';
import '../widgets/resident_summary_stat.dart';
import 'resident_form_screen.dart';

/// Màn hình Quản lý cư dân (Thêm, Sửa, Xoá) dành riêng cho Admin và Trưởng thôn.
class ResidentManagementScreen extends StatefulWidget {
  const ResidentManagementScreen({
    super.key,
    required this.viewModel,
    required this.currentUser,
  });

  final ResidentManagementViewModel viewModel;
  final ResidentAccount currentUser;

  @override
  State<ResidentManagementScreen> createState() =>
      _ResidentManagementScreenState();
}

class _ResidentManagementScreenState extends State<ResidentManagementScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openForm({ResidentAccount? existing}) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => ResidentFormScreen(
          viewModel: widget.viewModel,
          initialResident: existing,
        ),
      ),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            existing == null
                ? 'Đã thêm cư dân mới thành công.'
                : 'Đã cập nhật thông tin cư dân.',
          ),
        ),
      );
    }
  }

  Future<void> _confirmDelete(ResidentAccount resident) async {
    if (resident.id == widget.currentUser.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Không thể xoá tài khoản đang đăng nhập tại đây. '
            'Vui lòng dùng mục Xoá tài khoản trong Cài đặt.',
          ),
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xoá cư dân'),
          content: Text(
            'Bạn có chắc chắn muốn xoá hồ sơ của "${resident.fullName}" '
            '(CCCD: ${resident.citizenId}) khỏi danh sách cư dân xã không?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Huỷ'),
            ),
            FilledButton(
              key: const ValueKey('confirm_delete_resident_btn'),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Xoá'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      final error = widget.viewModel.deleteResident(resident.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Đã xoá cư dân "${resident.fullName}".'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.currentUser.role.canManageResidents) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quản lý cư dân')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Bạn không có quyền truy cập chức năng này. '
              'Chỉ Admin hoặc Trưởng thôn mới được quản lý danh sách cư dân.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý cư dân')),
      floatingActionButton: FloatingActionButton.extended(
        key: const ValueKey('add_resident_fab'),
        onPressed: () => _openForm(),
        icon: const Icon(Icons.person_add_alt_1_outlined),
        label: const Text('Thêm cư dân'),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          final residents = widget.viewModel.residents;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ResidentSummaryStat(
                            icon: Icons.groups_outlined,
                            label: 'Tổng cư dân',
                            value: '${widget.viewModel.totalResidents}',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ResidentSummaryStat(
                            icon: Icons.home_work_outlined,
                            label: 'Hộ gia đình',
                            value: '${widget.viewModel.totalHouseholds}',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      key: const ValueKey('resident_search_field'),
                      controller: _searchController,
                      onChanged: widget.viewModel.setQuery,
                      decoration: InputDecoration(
                        hintText: 'Tìm theo tên, CCCD, SĐT, mã hộ...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  widget.viewModel.setQuery('');
                                },
                                icon: const Icon(Icons.clear),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 54,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  children: [
                    ChoiceChip(
                      label: const Text('Tất cả'),
                      selected: widget.viewModel.roleFilter == null,
                      onSelected: (_) => widget.viewModel.setRoleFilter(null),
                    ),
                    ...UserRole.values.map((role) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ChoiceChip(
                          label: Text(role.displayName),
                          selected: widget.viewModel.roleFilter == role,
                          onSelected: (_) =>
                              widget.viewModel.setRoleFilter(role),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Expanded(
                child: residents.isEmpty
                    ? Center(
                        child: Text(
                          'Không tìm thấy cư dân phù hợp.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                        itemCount: residents.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final resident = residents[index];
                          return ResidentCard(
                            resident: resident,
                            isCurrentUser: resident.id == widget.currentUser.id,
                            onEdit: () => _openForm(existing: resident),
                            onDelete: () => _confirmDelete(resident),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
