import 'package:flutter/material.dart';

import '../../../../domain/models/household_info.dart';
import '../../../../domain/models/resident_account.dart';
import '../view_models/profile_view_model.dart';

/// Màn hình chỉnh sửa thông tin cá nhân và thành viên hộ gia đình.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    required this.viewModel,
    required this.account,
  });

  final ProfileViewModel viewModel;
  final ResidentAccount account;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const List<String> _villages = <String>[
    'Thôn Đông',
    'Thôn Đoài',
    'Thôn Bắc',
    'Thôn Nam',
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _citizenIdController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _householdCodeController;
  late final TextEditingController _headOfHouseholdController;
  late String _selectedVillage;
  late List<HouseholdMember> _members;

  @override
  void initState() {
    super.initState();
    final acc = widget.account;
    _nameController = TextEditingController(text: acc.fullName);
    _citizenIdController = TextEditingController(text: acc.citizenId);
    _phoneController = TextEditingController(text: acc.phoneNumber);
    _addressController = TextEditingController(text: acc.address);
    _householdCodeController = TextEditingController(
      text: acc.household.householdCode,
    );
    _headOfHouseholdController = TextEditingController(
      text: acc.household.headOfHousehold,
    );
    _selectedVillage = acc.village;
    _members = List<HouseholdMember>.of(acc.household.members);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _citizenIdController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _householdCodeController.dispose();
    _headOfHouseholdController.dispose();
    super.dispose();
  }

  Future<void> _addMemberDialog() async {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final relationCtrl = TextEditingController();
    final yearCtrl = TextEditingController();

    final added = await showDialog<HouseholdMember>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm thành viên hộ gia đình'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(labelText: 'Họ và tên *'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập họ tên';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: relationCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Quan hệ với chủ hộ *',
                      hintText: 'Ví dụ: Vợ, Con trai, Mẹ...',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập quan hệ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: yearCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Năm sinh *'),
                    validator: (value) {
                      final year = int.tryParse(value?.trim() ?? '');
                      if (year == null ||
                          year < 1900 ||
                          year > DateTime.now().year) {
                        return 'Năm sinh không hợp lệ';
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Huỷ'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  Navigator.of(context).pop(
                    HouseholdMember(
                      fullName: nameCtrl.text.trim(),
                      relationship: relationCtrl.text.trim(),
                      birthYear: int.parse(yearCtrl.text.trim()),
                    ),
                  );
                }
              },
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );

    nameCtrl.dispose();
    relationCtrl.dispose();
    yearCtrl.dispose();

    if (added != null) {
      setState(() {
        _members.add(added);
      });
    }
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final address = _addressController.text.trim();
    final updated = widget.account.copyWith(
      fullName: _nameController.text.trim(),
      citizenId: _citizenIdController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      address: address,
      village: _selectedVillage,
      household: widget.account.household.copyWith(
        householdCode: _householdCodeController.text.trim().toUpperCase(),
        village: _selectedVillage,
        headOfHousehold: _headOfHouseholdController.text.trim(),
        registeredAddress: address,
        members: List<HouseholdMember>.unmodifiable(_members),
      ),
    );

    final error = widget.viewModel.updateProfile(updated);
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa thông tin')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                key: const ValueKey('edit_profile_name'),
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Tên tài khoản / Họ và tên *',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập họ và tên';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('edit_profile_cccd'),
                controller: _citizenIdController,
                keyboardType: TextInputType.number,
                maxLength: 12,
                decoration: const InputDecoration(
                  labelText: 'Căn cước công dân *',
                  prefixIcon: Icon(Icons.credit_card_outlined),
                  counterText: '',
                ),
                validator: (value) {
                  if (!RegExp(r'^\d{12}$').hasMatch(value?.trim() ?? '')) {
                    return 'Số CCCD phải gồm đúng 12 chữ số';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('edit_profile_phone'),
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 11,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại *',
                  prefixIcon: Icon(Icons.phone_outlined),
                  counterText: '',
                ),
                validator: (value) {
                  if (!RegExp(r'^0\d{9,10}$').hasMatch(value?.trim() ?? '')) {
                    return 'Số điện thoại phải bắt đầu bằng 0 (10-11 chữ số)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              Text('Thôn / Khu vực', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _villages.map((village) {
                  return ChoiceChip(
                    label: Text(village),
                    selected: _selectedVillage == village,
                    onSelected: (_) {
                      setState(() {
                        _selectedVillage = village;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('edit_profile_address'),
                controller: _addressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ *',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập địa chỉ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Thông tin hộ gia đình',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                key: const ValueKey('edit_profile_household_code'),
                controller: _householdCodeController,
                decoration: const InputDecoration(
                  labelText: 'Mã hộ gia đình *',
                  prefixIcon: Icon(Icons.family_restroom_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập mã hộ gia đình';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('edit_profile_head'),
                controller: _headOfHouseholdController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Chủ hộ *',
                  prefixIcon: Icon(Icons.supervisor_account_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên chủ hộ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(
                    'Thành viên trong hộ (${_members.length})',
                    style: theme.textTheme.titleSmall,
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _addMemberDialog,
                    icon: const Icon(Icons.person_add_outlined, size: 18),
                    label: const Text('Thêm'),
                  ),
                ],
              ),
              ...List<Widget>.generate(_members.length, (index) {
                final member = _members[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(member.fullName),
                    subtitle: Text(
                      '${member.relationship} • Sinh năm ${member.birthYear}',
                    ),
                    trailing: _members.length > 1
                        ? IconButton(
                            tooltip: 'Xoá thành viên',
                            onPressed: () {
                              setState(() {
                                _members.removeAt(index);
                              });
                            },
                            icon: Icon(
                              Icons.delete_outline,
                              color: theme.colorScheme.error,
                            ),
                          )
                        : null,
                  ),
                );
              }),
              const SizedBox(height: 20),
              FilledButton.icon(
                key: const ValueKey('edit_profile_save'),
                onPressed: _save,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.save_outlined),
                label: const Text(
                  'Lưu hồ sơ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
