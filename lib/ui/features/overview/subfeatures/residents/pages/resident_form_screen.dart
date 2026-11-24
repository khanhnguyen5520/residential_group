import 'package:flutter/material.dart';
import 'package:residential_group/domain/models/household_info.dart';
import 'package:residential_group/domain/models/resident_account.dart';
import 'package:residential_group/domain/models/user_role.dart';
import 'package:residential_group/ui/core/utils/date_formatter.dart';

import '../view_models/resident_management_view_model.dart';

/// Màn hình Thêm mới hoặc Chỉnh sửa thông tin cư dân (dành cho Admin & Trưởng thôn).
class ResidentFormScreen extends StatefulWidget {
  const ResidentFormScreen({
    super.key,
    required this.viewModel,
    this.initialResident,
  });

  final ResidentManagementViewModel viewModel;
  final ResidentAccount? initialResident;

  bool get isEditing => initialResident != null;

  @override
  State<ResidentFormScreen> createState() => _ResidentFormScreenState();
}

class _ResidentFormScreenState extends State<ResidentFormScreen> {
  static const List<String> _villages = <String>[
    'Thôn Đông',
    'Thôn Đoài',
    'Thôn Bắc',
    'Thôn Nam',
  ];

  static const List<int> _avatarPalette = <int>[
    0xFF0F6B5E,
    0xFF1D6295,
    0xFFC46D12,
    0xFFB3261E,
    0xFF3E6B48,
    0xFF7B4B94,
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _citizenIdController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _householdCodeController;
  late final TextEditingController _headOfHouseholdController;

  late UserRole _selectedRole;
  late String _selectedGender;
  late String _selectedVillage;
  late DateTime _dateOfBirth;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialResident;
    _nameController = TextEditingController(text: initial?.fullName ?? '');
    _citizenIdController = TextEditingController(
      text: initial?.citizenId ?? '',
    );
    _phoneController = TextEditingController(text: initial?.phoneNumber ?? '');
    _addressController = TextEditingController(text: initial?.address ?? '');
    _householdCodeController = TextEditingController(
      text: initial?.household.householdCode ?? 'HK-TL-0009',
    );
    _headOfHouseholdController = TextEditingController(
      text: initial?.household.headOfHousehold ?? '',
    );

    _selectedRole = initial?.role ?? UserRole.resident;
    _selectedGender = initial?.gender ?? 'Nam';
    _selectedVillage = initial?.village ?? _villages.first;
    _dateOfBirth = initial?.dateOfBirth ?? DateTime(1992, 1, 1);
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

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final name = _nameController.text.trim();
    final address = _addressController.text.trim();
    final householdCode = _householdCodeController.text.trim().toUpperCase();
    final headName = _headOfHouseholdController.text.trim().isEmpty
        ? name
        : _headOfHouseholdController.text.trim();

    final existing = widget.initialResident;
    final members = existing != null
        ? existing.household.members
        : <HouseholdMember>[
            HouseholdMember(
              fullName: name,
              relationship: headName == name ? 'Chủ hộ' : 'Thành viên',
              birthYear: _dateOfBirth.year,
            ),
          ];

    final household = HouseholdInfo(
      householdCode: householdCode,
      village: _selectedVillage,
      headOfHousehold: headName,
      registeredAddress: address,
      members: members,
    );

    final account = existing != null
        ? existing.copyWith(
            fullName: name,
            role: _selectedRole,
            citizenId: _citizenIdController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            address: address,
            village: _selectedVillage,
            dateOfBirth: _dateOfBirth,
            gender: _selectedGender,
            household: household,
          )
        : ResidentAccount(
            id: 'res-${DateTime.now().microsecondsSinceEpoch}',
            fullName: name,
            role: _selectedRole,
            citizenId: _citizenIdController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            address: address,
            village: _selectedVillage,
            dateOfBirth: _dateOfBirth,
            gender: _selectedGender,
            household: household,
            password: '123456',
            avatarColorValue:
                _avatarPalette[name.length % _avatarPalette.length],
          );

    final error = widget.isEditing
        ? widget.viewModel.updateResident(account)
        : widget.viewModel.addResident(account);

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
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Sửa thông tin cư dân' : 'Thêm cư dân'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                key: const ValueKey('resident_form_name'),
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên *',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập họ và tên';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text('Phân cấp tài khoản', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: UserRole.values.map((role) {
                  return ChoiceChip(
                    label: Text(role.displayName),
                    selected: _selectedRole == role,
                    onSelected: (_) {
                      setState(() {
                        _selectedRole = role;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const ValueKey('resident_form_cccd'),
                controller: _citizenIdController,
                keyboardType: TextInputType.number,
                maxLength: 12,
                decoration: const InputDecoration(
                  labelText: 'Số căn cước công dân (12 số) *',
                  prefixIcon: Icon(Icons.credit_card_outlined),
                  counterText: '',
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (!RegExp(r'^\d{12}$').hasMatch(text)) {
                    return 'Số CCCD phải gồm đúng 12 chữ số';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('resident_form_phone'),
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 11,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại *',
                  prefixIcon: Icon(Icons.phone_outlined),
                  counterText: '',
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (!RegExp(r'^0\d{9,10}$').hasMatch(text)) {
                    return 'Số điện thoại phải bắt đầu bằng 0 (10-11 chữ số)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Giới tính', style: theme.textTheme.titleSmall),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: ['Nam', 'Nữ'].map((gender) {
                            return ChoiceChip(
                              label: Text(gender),
                              selected: _selectedGender == gender,
                              onSelected: (_) {
                                setState(() {
                                  _selectedGender = gender;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ngày sinh', style: theme.textTheme.titleSmall),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _pickBirthDate,
                          borderRadius: BorderRadius.circular(12),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.cake_outlined, size: 18),
                            ),
                            child: Text(DateFormatter.formatDate(_dateOfBirth)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 14),
              TextFormField(
                key: const ValueKey('resident_form_address'),
                controller: _addressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ thường trú *',
                  prefixIcon: Icon(Icons.home_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập địa chỉ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('resident_form_household_code'),
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
                key: const ValueKey('resident_form_head'),
                controller: _headOfHouseholdController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Họ tên chủ hộ',
                  hintText: 'Để trống nếu chính cư dân là chủ hộ',
                  prefixIcon: Icon(Icons.supervisor_account_outlined),
                ),
              ),
              if (!widget.isEditing) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Mật khẩu đăng nhập mặc định cho tài khoản mới là: 123456',
                          style: TextStyle(fontSize: 12.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton.icon(
                key: const ValueKey('resident_form_submit'),
                onPressed: _submit,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.save_outlined),
                label: Text(
                  widget.isEditing ? 'Lưu thay đổi' : 'Thêm cư dân mới',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
