/// Vai trò phân cấp tài khoản trong hệ thống quản lý dân cư xã.
enum UserRole {
  admin,
  villageHead,
  deputyHead,
  resident;

  /// Tên hiển thị tiếng Việt cho từng cấp tài khoản.
  String get displayName => switch (this) {
    UserRole.admin => 'Admin',
    UserRole.villageHead => 'Trưởng thôn',
    UserRole.deputyHead => 'Phó thôn',
    UserRole.resident => 'Cư dân',
  };

  /// Mô tả ngắn về phạm vi quyền hạn.
  String get subtitle => switch (this) {
    UserRole.admin => 'Quản trị toàn xã • Toàn quyền quản lý cư dân',
    UserRole.villageHead => 'Ngang hàng Admin • Toàn quyền quản lý cư dân',
    UserRole.deputyHead => 'Hỗ trợ điều hành thôn • Xem thông tin & tương tác',
    UserRole.resident => 'Thành viên hộ gia đình • Cập nhật hồ sơ & phản ánh',
  };

  /// Admin và Trưởng thôn có quyền ngang hàng trong quản lý cư dân và xử lý ý kiến.
  bool get canManageResidents =>
      this == UserRole.admin || this == UserRole.villageHead;

  /// Các tài khoản thuộc ban điều hành xã/thôn.
  bool get isLeadership => this != UserRole.resident;
}
