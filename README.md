# Quản lý Dân cư Xã (`residential_group`)

Ứng dụng di động Flutter phục vụ công tác quản lý dân cư của một xã, hỗ trợ phân cấp tài khoản rõ ràng giữa ban điều hành xã/thôn và cư dân.

---

## 1. Phân cấp tài khoản & Tài khoản mẫu

Hệ thống chia làm **4 cấp tài khoản** với mật khẩu mặc định là `123456` (hỗ trợ đăng nhập bằng Số điện thoại/CCCD hoặc chọn nhanh 1 chạm ở màn Đăng nhập):

| Cấp tài khoản | Họ tên mẫu | Số điện thoại | Số CCCD | Quyền hạn |
| :--- | :--- | :--- | :--- | :--- |
| **Admin** | Nguyễn Văn An | `0901000001` | `036085000001` | Toàn quyền: xem các mục chung, **Quản lý cư dân** (thêm/sửa/xoá) và phản hồi ý kiến |
| **Trưởng thôn** | Trần Thị Bình | `0901000002` | `036187000002` | **Ngang hàng Admin**: có đầy đủ mục **Quản lý cư dân** và phản hồi ý kiến |
| **Phó thôn** | Lê Minh Cường | `0901000003` | `036090000003` | Xem Tin tức, Khảo sát, Ý kiến, Lịch họp; không có quyền quản lý cư dân |
| **Cư dân** | Phạm Thu Dung | `0901000004` | `036195000004` | Xem Tin tức, Khảo sát, Ý kiến, Lịch họp; xem và chỉnh sửa hồ sơ cá nhân |

---

## 2. Các màn hình và chức năng chính

Ứng dụng sử dụng thanh điều hướng nổi (**Floating Pill Bottom Navigation**) gồm **4 tab chính**:

### Tab 1: Tổng quan
- **Phần trên cùng**: Hiển thị **tên chủ tài khoản**, **avatar**, huy hiệu phân cấp vai trò và địa bàn thôn/xã.
- **Phần bên dưới (dạng lưới 2 cột)**:
  - **Tin tức**: Xem bản tin xã/thôn, lọc theo chuyên mục và xem chi tiết bài viết.
  - **Khảo sát**: Tham gia bình chọn khảo sát cộng đồng và xem tỷ lệ phần trăm theo thời gian thực.
  - **Ý kiến**: Xem danh sách phản ánh/kiến nghị, gửi ý kiến mới; riêng `Admin` và `Trưởng thôn` có thêm chức năng phản hồi và cập nhật trạng thái xử lý.
  - **Lịch họp**:
    - Hỗ trợ nút chuyển **Ngày / Tháng**:
      - Chế độ **Ngày**: Hiển thị danh sách thẻ lịch họp, chi tiết thời gian/địa điểm/chủ trì và xác nhận tham dự.
      - Chế độ **Tháng**: Nửa trên là lịch tháng của ngày hiện tại (có thể lướt ngang để xem các tháng khác, đánh dấu chấm tròn ở những ngày có lịch họp); nửa dưới hiển thị danh sách sự kiện của ngày được chọn hoặc thông báo *"Không có cuộc họp vào ngày này"*.
  - **Quản lý cư dân** *(chỉ hiển thị với tài khoản `Admin` hoặc `Trưởng thôn`)*: Thống kê tổng cư dân & hộ gia đình, tìm kiếm/lọc theo vai trò, **thêm mới**, **chỉnh sửa thông tin** và **xoá** hồ sơ cư dân.

### Tab 2: Thông báo
- Hiển thị danh sách thông báo kèm huy hiệu số lượng chưa đọc trên thanh điều hướng và nút **Đọc tất cả**.
- **Bộ lọc thời gian**: `Tất cả`, `Hôm nay`, `7 ngày qua`, `30 ngày qua` và `Tuỳ chọn` (chọn khoảng ngày).
- **Trình sắp xếp thứ tự**: `Mới nhất` hoặc `Cũ nhất`.

### Tab 3: Cài đặt
Danh sách 6 chức năng:
1. **Chế độ sáng**: Bật/tắt giao diện Sáng / Tối trực tiếp cho toàn ứng dụng.
2. **Thông tin ứng dụng**: Tên ứng dụng, phiên bản và thông tin đơn vị triển khai.
3. **Điều khoản sử dụng**: Quy định phạm vi sử dụng, phân cấp quyền và bảo mật thông tin.
4. **Đổi mật khẩu**: Xác thực mật khẩu hiện tại và cập nhật mật khẩu mới.
5. **Đăng xuất**: Thoát phiên đăng nhập hiện tại về màn Đăng nhập.
6. **Xoá tài khoản**: Xác minh mật khẩu để xoá tài khoản khỏi hệ thống.

### Tab 4: Profile
- **Phần trên cùng**: Hiển thị avatar, **tên người tài khoản kèm icon chỉnh sửa** (mở màn hình cập nhật thông tin cá nhân & thành viên hộ gia đình, đồng bộ ngay sang tab Tổng quan).
- **Phần bên dưới**:
  - **Căn cước công dân** (có nút sao chép).
  - **Số điện thoại**.
  - **Địa chỉ**.
  - **Thông tin hộ gia đình** (mã hộ khẩu, chủ hộ, khu vực, số nhân khẩu và danh sách thành viên trong hộ).

---

## 3. Kiến trúc mã nguồn

```text
lib/
├── app.dart                  # Khởi tạo dependency và cấu hình MaterialApp (Light/Dark theme)
├── main.dart                 # Entry point ứng dụng
├── domain/models/            # Các immutable domain model & logic phân quyền (UserRole)
├── data/
│   ├── services/             # Dữ liệu mẫu (SeedData) & InMemoryCommuneService
│   └── repositories/         # Auth, Resident, Notification, Community repositories
└── ui/
    ├── core/                 # Theme Material 3, DateFormatter, UserAvatar, RoleBadge
    └── features/             # MVVM (view_models + views) cho auth, home, overview, notifications, settings, profile
```

---

## 4. Hướng dẫn chạy và kiểm thử

```bash
# Cài đặt dependencies
flutter pub get

# Chạy ứng dụng trên thiết bị/máy ảo
flutter run

# Kiểm tra phân tích tĩnh
flutter analyze --fatal-infos

# Chạy toàn bộ unit test và widget test
flutter test
```
