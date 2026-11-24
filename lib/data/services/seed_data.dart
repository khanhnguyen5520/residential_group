import '../../domain/models/app_notification.dart';
import '../../domain/models/citizen_feedback.dart';
import '../../domain/models/household_info.dart';
import '../../domain/models/meeting_schedule.dart';
import '../../domain/models/news_article.dart';
import '../../domain/models/resident_account.dart';
import '../../domain/models/survey.dart';
import '../../domain/models/user_role.dart';

/// Tạo dữ liệu mẫu thực tế cho ứng dụng quản lý dân cư Xã Tân Lập.
abstract final class SeedData {
  static const String defaultPassword = '123456';

  static List<ResidentAccount> createResidents() {
    return <ResidentAccount>[
      ResidentAccount(
        id: 'res-admin-1',
        fullName: 'Nguyễn Văn An',
        role: UserRole.admin,
        citizenId: '036085000001',
        phoneNumber: '0901000001',
        address: 'Số 12, Đường Trục Chính, Thôn Đông, Xã Tân Lập',
        village: 'Thôn Đông',
        dateOfBirth: DateTime(1985, 4, 15),
        gender: 'Nam',
        password: defaultPassword,
        avatarColorValue: 0xFFB3261E,
        household: const HouseholdInfo(
          householdCode: 'HK-TL-0001',
          village: 'Thôn Đông',
          headOfHousehold: 'Nguyễn Văn An',
          registeredAddress: 'Số 12, Đường Trục Chính, Thôn Đông, Xã Tân Lập',
          members: <HouseholdMember>[
            HouseholdMember(
              fullName: 'Nguyễn Văn An',
              relationship: 'Chủ hộ',
              birthYear: 1985,
            ),
            HouseholdMember(
              fullName: 'Đỗ Thị Hạnh',
              relationship: 'Vợ',
              birthYear: 1988,
            ),
            HouseholdMember(
              fullName: 'Nguyễn Gia Huy',
              relationship: 'Con trai',
              birthYear: 2014,
            ),
          ],
        ),
      ),
      ResidentAccount(
        id: 'res-head-1',
        fullName: 'Trần Thị Bình',
        role: UserRole.villageHead,
        citizenId: '036187000002',
        phoneNumber: '0901000002',
        address: 'Số 28, Ngõ Hoa Sen, Thôn Đông, Xã Tân Lập',
        village: 'Thôn Đông',
        dateOfBirth: DateTime(1987, 9, 20),
        gender: 'Nữ',
        password: defaultPassword,
        avatarColorValue: 0xFF0F6B5E,
        household: const HouseholdInfo(
          householdCode: 'HK-TL-0002',
          village: 'Thôn Đông',
          headOfHousehold: 'Trần Thị Bình',
          registeredAddress: 'Số 28, Ngõ Hoa Sen, Thôn Đông, Xã Tân Lập',
          members: <HouseholdMember>[
            HouseholdMember(
              fullName: 'Trần Thị Bình',
              relationship: 'Chủ hộ',
              birthYear: 1987,
            ),
            HouseholdMember(
              fullName: 'Hoàng Văn Nam',
              relationship: 'Chồng',
              birthYear: 1984,
            ),
            HouseholdMember(
              fullName: 'Hoàng Minh Anh',
              relationship: 'Con gái',
              birthYear: 2016,
            ),
          ],
        ),
      ),
      ResidentAccount(
        id: 'res-deputy-1',
        fullName: 'Lê Minh Cường',
        role: UserRole.deputyHead,
        citizenId: '036090000003',
        phoneNumber: '0901000003',
        address: 'Số 05, Xóm Giếng, Thôn Đoài, Xã Tân Lập',
        village: 'Thôn Đoài',
        dateOfBirth: DateTime(1990, 2, 11),
        gender: 'Nam',
        password: defaultPassword,
        avatarColorValue: 0xFFC46D12,
        household: const HouseholdInfo(
          householdCode: 'HK-TL-0003',
          village: 'Thôn Đoài',
          headOfHousehold: 'Lê Minh Cường',
          registeredAddress: 'Số 05, Xóm Giếng, Thôn Đoài, Xã Tân Lập',
          members: <HouseholdMember>[
            HouseholdMember(
              fullName: 'Lê Minh Cường',
              relationship: 'Chủ hộ',
              birthYear: 1990,
            ),
            HouseholdMember(
              fullName: 'Vũ Thị Mai',
              relationship: 'Vợ',
              birthYear: 1992,
            ),
            HouseholdMember(
              fullName: 'Lê Bảo Long',
              relationship: 'Con trai',
              birthYear: 2018,
            ),
            HouseholdMember(
              fullName: 'Lê Thảo Vy',
              relationship: 'Con gái',
              birthYear: 2021,
            ),
          ],
        ),
      ),
      ResidentAccount(
        id: 'res-citizen-1',
        fullName: 'Phạm Thu Dung',
        role: UserRole.resident,
        citizenId: '036195000004',
        phoneNumber: '0901000004',
        address: 'Số 44, Đường Bờ Kênh, Thôn Bắc, Xã Tân Lập',
        village: 'Thôn Bắc',
        dateOfBirth: DateTime(1995, 11, 8),
        gender: 'Nữ',
        password: defaultPassword,
        avatarColorValue: 0xFF1D6295,
        household: const HouseholdInfo(
          householdCode: 'HK-TL-0004',
          village: 'Thôn Bắc',
          headOfHousehold: 'Phạm Văn Hùng',
          registeredAddress: 'Số 44, Đường Bờ Kênh, Thôn Bắc, Xã Tân Lập',
          members: <HouseholdMember>[
            HouseholdMember(
              fullName: 'Phạm Văn Hùng',
              relationship: 'Chủ hộ',
              birthYear: 1966,
            ),
            HouseholdMember(
              fullName: 'Nguyễn Thị Lan',
              relationship: 'Vợ',
              birthYear: 1969,
            ),
            HouseholdMember(
              fullName: 'Phạm Thu Dung',
              relationship: 'Con gái',
              birthYear: 1995,
            ),
            HouseholdMember(
              fullName: 'Phạm Quang Khải',
              relationship: 'Con trai',
              birthYear: 1999,
            ),
          ],
        ),
      ),
      ResidentAccount(
        id: 'res-citizen-2',
        fullName: 'Đặng Quốc Bảo',
        role: UserRole.resident,
        citizenId: '036078000005',
        phoneNumber: '0901000005',
        address: 'Số 19, Xóm Chùa, Thôn Nam, Xã Tân Lập',
        village: 'Thôn Nam',
        dateOfBirth: DateTime(1978, 6, 3),
        gender: 'Nam',
        password: defaultPassword,
        avatarColorValue: 0xFF3E6B48,
        household: const HouseholdInfo(
          householdCode: 'HK-TL-0005',
          village: 'Thôn Nam',
          headOfHousehold: 'Đặng Quốc Bảo',
          registeredAddress: 'Số 19, Xóm Chùa, Thôn Nam, Xã Tân Lập',
          members: <HouseholdMember>[
            HouseholdMember(
              fullName: 'Đặng Quốc Bảo',
              relationship: 'Chủ hộ',
              birthYear: 1978,
            ),
            HouseholdMember(
              fullName: 'Bùi Thị Nga',
              relationship: 'Vợ',
              birthYear: 1981,
            ),
          ],
        ),
      ),
      ResidentAccount(
        id: 'res-citizen-3',
        fullName: 'Ngô Thị Kim Oanh',
        role: UserRole.resident,
        citizenId: '036192000006',
        phoneNumber: '0901000006',
        address: 'Số 71, Khu Chợ Mới, Thôn Đoài, Xã Tân Lập',
        village: 'Thôn Đoài',
        dateOfBirth: DateTime(1992, 1, 25),
        gender: 'Nữ',
        password: defaultPassword,
        avatarColorValue: 0xFF7B4B94,
        household: const HouseholdInfo(
          householdCode: 'HK-TL-0006',
          village: 'Thôn Đoài',
          headOfHousehold: 'Ngô Thị Kim Oanh',
          registeredAddress: 'Số 71, Khu Chợ Mới, Thôn Đoài, Xã Tân Lập',
          members: <HouseholdMember>[
            HouseholdMember(
              fullName: 'Ngô Thị Kim Oanh',
              relationship: 'Chủ hộ',
              birthYear: 1992,
            ),
            HouseholdMember(
              fullName: 'Trương Minh Nhật',
              relationship: 'Con trai',
              birthYear: 2019,
            ),
          ],
        ),
      ),
      ResidentAccount(
        id: 'res-head-2',
        fullName: 'Võ Thành Tâm',
        role: UserRole.villageHead,
        citizenId: '036080000007',
        phoneNumber: '0901000007',
        address: 'Số 09, Đường Cây Đa, Thôn Nam, Xã Tân Lập',
        village: 'Thôn Nam',
        dateOfBirth: DateTime(1980, 12, 12),
        gender: 'Nam',
        password: defaultPassword,
        avatarColorValue: 0xFF0B6E4F,
        household: const HouseholdInfo(
          householdCode: 'HK-TL-0007',
          village: 'Thôn Nam',
          headOfHousehold: 'Võ Thành Tâm',
          registeredAddress: 'Số 09, Đường Cây Đa, Thôn Nam, Xã Tân Lập',
          members: <HouseholdMember>[
            HouseholdMember(
              fullName: 'Võ Thành Tâm',
              relationship: 'Chủ hộ',
              birthYear: 1980,
            ),
            HouseholdMember(
              fullName: 'Phan Thị Hoa',
              relationship: 'Vợ',
              birthYear: 1983,
            ),
            HouseholdMember(
              fullName: 'Võ Ngọc Hân',
              relationship: 'Con gái',
              birthYear: 2010,
            ),
          ],
        ),
      ),
      ResidentAccount(
        id: 'res-citizen-4',
        fullName: 'Bùi Hải Đăng',
        role: UserRole.resident,
        citizenId: '036098000008',
        phoneNumber: '0901000008',
        address: 'Số 33, Xóm Mới, Thôn Bắc, Xã Tân Lập',
        village: 'Thôn Bắc',
        dateOfBirth: DateTime(1998, 7, 19),
        gender: 'Nam',
        password: defaultPassword,
        avatarColorValue: 0xFF2B59C3,
        household: const HouseholdInfo(
          householdCode: 'HK-TL-0008',
          village: 'Thôn Bắc',
          headOfHousehold: 'Bùi Hải Đăng',
          registeredAddress: 'Số 33, Xóm Mới, Thôn Bắc, Xã Tân Lập',
          members: <HouseholdMember>[
            HouseholdMember(
              fullName: 'Bùi Hải Đăng',
              relationship: 'Chủ hộ',
              birthYear: 1998,
            ),
          ],
        ),
      ),
    ];
  }

  static List<AppNotification> createNotifications({DateTime? now}) {
    final anchor = now ?? DateTime.now();
    final todayStart = DateTime(anchor.year, anchor.month, anchor.day);

    final todayOne = anchor.isAfter(todayStart.add(const Duration(hours: 1)))
        ? anchor.subtract(const Duration(hours: 1))
        : todayStart.add(const Duration(minutes: 20));
    final todayTwo = anchor.isAfter(todayStart.add(const Duration(hours: 4)))
        ? anchor.subtract(const Duration(hours: 4))
        : todayStart.add(const Duration(minutes: 5));

    DateTime daysAgo(int days, int hour, int minute) {
      return DateTime(
        anchor.year,
        anchor.month,
        anchor.day,
        hour,
        minute,
      ).subtract(Duration(days: days));
    }

    return <AppNotification>[
      AppNotification(
        id: 'noti-1',
        title: 'Lịch cắt điện bảo trì lưới điện Thôn Đông & Thôn Đoài',
        body:
            'Điện lực huyện thông báo tạm ngừng cấp điện từ 07:30 đến 11:30 ngày mai để nâng cấp trạm biến áp số 2. Đề nghị các hộ gia đình chủ động sắp xếp sinh hoạt và sản xuất.',
        category: NotificationCategory.general,
        createdAt: todayOne,
        isRead: false,
      ),
      AppNotification(
        id: 'noti-2',
        title: 'Mời họp triển khai tuyến đường giao thông nông thôn mới',
        body:
            'UBND Xã Tân Lập kính mời đại diện các hộ dân và Ban điều hành các thôn tham dự buổi họp thống nhất phương án mở rộng tuyến đường liên thôn vào 19:30 tối thứ Sáu tại Hội trường UBND xã.',
        category: NotificationCategory.meeting,
        createdAt: todayTwo,
        isRead: false,
      ),
      AppNotification(
        id: 'noti-3',
        title: 'Khảo sát lắp đặt hệ thống đèn chiếu sáng năng lượng mặt trời',
        body:
            'Ban quản lý xã đang lấy ý kiến cư dân về 3 vị trí ưu tiên lắp đặt đèn đường trong quý này. Thời hạn tham gia bình chọn đến hết tuần sau.',
        category: NotificationCategory.survey,
        createdAt: daysAgo(2, 16, 30),
        isRead: false,
      ),
      AppNotification(
        id: 'noti-4',
        title: 'Thông báo lịch tiêm phòng vắc xin mở rộng cho trẻ em',
        body:
            'Trạm Y tế Xã Tân Lập tổ chức tiêm chủng định kỳ cho trẻ dưới 5 tuổi vào sáng thứ Tư hàng tuần. Phụ huynh vui lòng mang theo sổ tiêm chủng và CCCD khi đến.',
        category: NotificationCategory.news,
        createdAt: daysAgo(5, 9, 15),
        isRead: true,
      ),
      AppNotification(
        id: 'noti-5',
        title: 'Rà soát, cập nhật thông tin nhân khẩu và căn cước công dân',
        body:
            'Đề nghị các hộ gia đình kiểm tra lại thông tin thành viên hộ khẩu trên mục Profile. Nếu có thay đổi về nhân khẩu hoặc số điện thoại, vui lòng cập nhật hoặc liên hệ Trưởng thôn.',
        category: NotificationCategory.resident,
        createdAt: daysAgo(12, 14, 0),
        isRead: true,
      ),
      AppNotification(
        id: 'noti-6',
        title: 'Kết quả tổng vệ sinh môi trường toàn xã tháng trước',
        body:
            'Toàn xã đã thu gom hơn 3,5 tấn rác thải sinh hoạt và khơi thông 4km kênh mương nội đồng. UBND xã biểu dương tinh thần tích cực của 4 thôn.',
        category: NotificationCategory.news,
        createdAt: daysAgo(25, 10, 45),
        isRead: true,
      ),
      AppNotification(
        id: 'noti-7',
        title: 'Thông báo thu quỹ phòng chống thiên tai năm nay',
        body:
            'Các trưởng thôn phối hợp tổ chức thu quỹ phòng chống thiên tai theo quy định và nộp biên lai về bộ phận tài chính UBND xã trước ngày cuối tháng.',
        category: NotificationCategory.general,
        createdAt: daysAgo(45, 8, 30),
        isRead: true,
      ),
    ];
  }

  static List<NewsArticle> createNews({DateTime? now}) {
    final anchor = now ?? DateTime.now();
    return <NewsArticle>[
      NewsArticle(
        id: 'news-1',
        title:
            'Xã Tân Lập khởi công nâng cấp tuyến đường trục liên thôn dài 2,4km',
        summary:
            'Công trình mở rộng mặt đường bê tông từ 3,5m lên 5,5m kèm rãnh thoát nước, dự kiến hoàn thành sau 90 ngày thi công.',
        content:
            'Sáng nay, UBND Xã Tân Lập phối hợp cùng Ban giám sát cộng đồng các thôn đã chính thức khởi công tuyến đường trục liên thôn nối Thôn Đông với Thôn Nam.\n\n'
            'Tuyến đường mới được thiết kế mặt bê tông dày 20cm, chiều rộng 5,5m, có hệ thống rãnh thoát nước hai bên và điểm tránh xe an toàn. Trong thời gian thi công, bà con lưu ý di chuyển theo biển chỉ dẫn để bảo đảm an toàn giao thông.',
        category: 'Hạ tầng',
        authorName: 'UBND Xã Tân Lập',
        publishedAt: anchor.subtract(const Duration(hours: 5)),
        isPinned: true,
      ),
      NewsArticle(
        id: 'news-2',
        title: 'Lịch hỗ trợ cài đặt VNeID và kích hoạt định danh điện tử mức 2',
        summary:
            'Tổ công nghệ số cộng đồng trực hỗ trợ người dân tại Nhà văn hoá các thôn vào thứ Bảy và Chủ nhật.',
        content:
            'Nhằm tạo thuận lợi cho bà con thực hiện thủ tục hành chính trực tuyến, Công an xã và Đoàn Thanh niên tổ chức điểm hỗ trợ lưu động tại 4 nhà văn hoá thôn từ 08:00 đến 16:30 cuối tuần này.\n\n'
            'Người dân khi đi mang theo CCCD gắn chip và điện thoại thông minh đã cài sẵn ứng dụng VNeID.',
        category: 'Hành chính công',
        authorName: 'Nguyễn Văn An (Admin)',
        publishedAt: anchor.subtract(const Duration(days: 2)),
      ),
      NewsArticle(
        id: 'news-3',
        title: 'Hướng dẫn phân loại rác thải sinh hoạt tại nguồn ở hộ gia đình',
        summary:
            'Mỗi hộ dân được phát 2 túi thu gom phân biệt rác hữu cơ dễ phân huỷ và rác tái chế.',
        content:
            'Từ đầu tháng tới, xe thu gom rác của xã sẽ thu theo 2 nhóm riêng biệt: rác hữu cơ vào thứ Hai, Tư, Sáu; rác tái chế và rác còn lại vào thứ Ba, Năm, Bảy.\n\n'
            'Trưởng thôn các khu vực sẽ phối hợp phát tờ rơi hướng dẫn chi tiết đến từng hộ gia đình.',
        category: 'Môi trường',
        authorName: 'Trần Thị Bình (Trưởng thôn)',
        publishedAt: anchor.subtract(const Duration(days: 6)),
      ),
      NewsArticle(
        id: 'news-4',
        title: 'Khám sức khoẻ miễn phí cho người cao tuổi trên địa bàn xã',
        summary:
            'Trạm Y tế xã tổ chức đo huyết áp, tiểu đường và tư vấn dinh dưỡng cho công dân từ 60 tuổi trở lên.',
        content:
            'Chương trình khám sức khoẻ định kỳ miễn phí diễn ra vào sáng ngày 28 hàng tháng tại Trạm Y tế Xã Tân Lập. Các gia đình đưa người thân cao tuổi đến khám vui lòng đăng ký trước với trưởng thôn để sắp xếp khung giờ hợp lý.',
        category: 'Y tế',
        authorName: 'Trạm Y tế Xã Tân Lập',
        publishedAt: anchor.subtract(const Duration(days: 11)),
      ),
    ];
  }

  static List<Survey> createSurveys({DateTime? now}) {
    final anchor = now ?? DateTime.now();
    return <Survey>[
      Survey(
        id: 'sur-1',
        title: 'Lựa chọn vị trí ưu tiên lắp đèn chiếu sáng năng lượng mặt trời',
        description:
            'Xã được phân bổ 25 bộ đèn năng lượng mặt trời trong quý này. Xin ý kiến bà con chọn khu vực cấp thiết nhất.',
        deadline: anchor.add(const Duration(days: 7)),
        options: const <SurveyOption>[
          SurveyOption(
            id: 'opt-1',
            label: 'Đoạn đường từ cổng trường Tiểu học đến ngã ba Thôn Đông',
            voteCount: 48,
          ),
          SurveyOption(
            id: 'opt-2',
            label: 'Tuyến bờ kênh qua Thôn Bắc (khu vực hay đi lại buổi tối)',
            voteCount: 35,
          ),
          SurveyOption(
            id: 'opt-3',
            label: 'Khu vực chợ mới Thôn Đoài và lối rẽ Xóm Giếng',
            voteCount: 27,
          ),
        ],
      ),
      Survey(
        id: 'sur-2',
        title: 'Khung giờ thuận tiện nhất để tổ chức họp dân cư hàng tháng',
        description:
            'Ban điều hành các thôn khảo sát khung giờ phù hợp để tỷ lệ hộ gia đình tham dự đạt cao nhất.',
        deadline: anchor.add(const Duration(days: 14)),
        options: const <SurveyOption>[
          SurveyOption(
            id: 'opt-1',
            label: '19:30 tối thứ Sáu hàng tháng',
            voteCount: 62,
          ),
          SurveyOption(
            id: 'opt-2',
            label: '08:00 sáng Chủ nhật',
            voteCount: 41,
          ),
          SurveyOption(
            id: 'opt-3',
            label: '19:30 tối thứ Bảy hàng tháng',
            voteCount: 29,
          ),
        ],
        votedOptionIdByUser: const <String, String>{'res-citizen-1': 'opt-1'},
      ),
      Survey(
        id: 'sur-3',
        title:
            'Đánh giá mức độ hài lòng về dịch vụ thu gom rác thải tháng vừa qua',
        description:
            'Kết quả khảo sát giúp UBND xã điều chỉnh lộ trình và giờ thu gom của đội vệ sinh.',
        deadline: anchor.subtract(const Duration(days: 2)),
        isClosed: true,
        options: const <SurveyOption>[
          SurveyOption(id: 'opt-1', label: 'Rất hài lòng', voteCount: 74),
          SurveyOption(id: 'opt-2', label: 'Hài lòng', voteCount: 39),
          SurveyOption(
            id: 'opt-3',
            label: 'Cần điều chỉnh giờ thu gom sớm hơn',
            voteCount: 18,
          ),
        ],
      ),
    ];
  }

  static List<CitizenFeedback> createFeedbacks({DateTime? now}) {
    final anchor = now ?? DateTime.now();
    return <CitizenFeedback>[
      CitizenFeedback(
        id: 'fb-1',
        title: 'Đề nghị khơi thông cống thoát nước đầu ngõ Hoa Sen',
        content:
            'Sau hai trận mưa lớn vừa qua, đoạn cống trước số nhà 30 bị đọng rác làm nước thoát chậm. Kính mong ban quản lý thôn cho kiểm tra và xử lý.',
        category: 'Hạ tầng & Môi trường',
        authorId: 'res-citizen-1',
        authorName: 'Phạm Thu Dung',
        createdAt: anchor.subtract(const Duration(days: 1, hours: 3)),
        status: FeedbackStatus.inProgress,
        officialReply:
            'Trưởng thôn Thôn Đông đã tiếp nhận và bố trí đội thanh niên kiểm tra khơi thông vào sáng mai.',
      ),
      CitizenFeedback(
        id: 'fb-2',
        title: 'Kiến nghị bổ sung gờ giảm tốc tại cổng trường mầm non xã',
        content:
            'Vào giờ tan học lúc 16:30 có nhiều xe tải nhỏ đi qua cổng trường khá nhanh. Đề nghị xã lắp thêm biển cảnh báo và gờ giảm tốc.',
        category: 'An toàn giao thông',
        authorId: 'res-citizen-2',
        authorName: 'Đặng Quốc Bảo',
        createdAt: anchor.subtract(const Duration(days: 4)),
        status: FeedbackStatus.pending,
      ),
      CitizenFeedback(
        id: 'fb-3',
        title: 'Bóng đèn chiếu sáng tại cột số 14 Xóm Chùa bị hỏng',
        content:
            'Đèn đường trước khu vực sân bóng Thôn Nam đã tắt 3 tối nay, mong bộ phận kỹ thuật thay thế giúp bà con.',
        category: 'Chiếu sáng công cộng',
        authorId: 'res-citizen-3',
        authorName: 'Ngô Thị Kim Oanh',
        createdAt: anchor.subtract(const Duration(days: 9)),
        status: FeedbackStatus.resolved,
        officialReply:
            'Đội kỹ thuật đã thay bóng LED mới ngày hôm qua và nghiệm thu hoạt động ổn định.',
      ),
    ];
  }

  static List<MeetingSchedule> createMeetings({DateTime? now}) {
    final anchor = now ?? DateTime.now();
    DateTime atHour(int dayOffset, int hour, int minute) {
      return DateTime(
        anchor.year,
        anchor.month,
        anchor.day,
        hour,
        minute,
      ).add(Duration(days: dayOffset));
    }

    return <MeetingSchedule>[
      MeetingSchedule(
        id: 'meet-1',
        title: 'Họp triển khai tuyến đường nông thôn mới & giải phóng mặt bằng',
        description:
            'Thông báo phương án thi công, lịch trình tạm đóng đường và thống nhất tổ giám sát cộng đồng.',
        startTime: atHour(1, 19, 30),
        endTime: atHour(1, 21, 0),
        location: 'Hội trường UBND Xã Tân Lập',
        hostName: 'Nguyễn Văn An (Admin)',
        scope: 'Toàn xã',
        confirmedUserIds: const <String>['res-admin-1', 'res-head-1'],
      ),
      MeetingSchedule(
        id: 'meet-2',
        title: 'Họp định kỳ Thôn Đông: Bình xét gia đình văn hoá quý IV',
        description:
            'Tổng kết phong trào vệ sinh môi trường, an ninh trật tự và bình xét danh hiệu gia đình văn hoá.',
        startTime: atHour(3, 19, 30),
        endTime: atHour(3, 21, 0),
        location: 'Nhà văn hoá Thôn Đông',
        hostName: 'Trần Thị Bình (Trưởng thôn)',
        scope: 'Thôn Đông',
        confirmedUserIds: const <String>['res-head-1'],
      ),
      MeetingSchedule(
        id: 'meet-3',
        title: 'Giao ban công tác dân cư và rà soát nhân khẩu các thôn',
        description:
            'Cập nhật danh sách hộ mới chuyển đến, trẻ em trong độ tuổi tiêm chủng và công tác an sinh xã hội.',
        startTime: atHour(6, 8, 30),
        endTime: atHour(6, 10, 30),
        location: 'Phòng họp số 2, UBND Xã Tân Lập',
        hostName: 'Nguyễn Văn An & Các Trưởng/Phó thôn',
        scope: 'Ban điều hành xã/thôn',
        confirmedUserIds: const <String>[
          'res-admin-1',
          'res-head-1',
          'res-deputy-1',
        ],
      ),
      MeetingSchedule(
        id: 'meet-4',
        title: 'Họp tổng kết công tác phòng chống thiên tai mùa mưa bão',
        description:
            'Đánh giá phương án trực ứng cứu và kiểm kê vật tư phòng hộ tại 4 thôn.',
        startTime: atHour(-5, 14, 0),
        endTime: atHour(-5, 16, 0),
        location: 'Hội trường UBND Xã Tân Lập',
        hostName: 'UBND Xã Tân Lập',
        scope: 'Toàn xã',
        confirmedUserIds: const <String>['res-admin-1', 'res-citizen-1'],
      ),
    ];
  }
}
