import 'package:flutter/material.dart';

class T {
  static ValueNotifier<Locale> locale = ValueNotifier(const Locale("vi"));

  static void changeLanguage(String code) {
    locale.value = const Locale("vi");
  }

  static bool get isEnglish => false;

  static String text(String key) {
    final vi = {
      // Login
      "loginTitle": "Đăng nhập Admin",
      "username": "Tên đăng nhập",
      "password": "Mật khẩu",
      "login": "Đăng nhập",

      // Dashboard / Drawer
      "surveyManagement": "Quản lí khảo sát",
      "searchSurvey": "Tìm khảo sát theo tên",
      "searchByMonth": "Tìm kiếm theo tháng",
      "allMonths": "Tất cả tháng",
      "month": "Tháng",
      "noSurvey": "Chưa có khảo sát nào",
      "manageSurvey": "Quản lý khảo sát",
      "surveyAnalysis": "Phân tích khảo sát",
      "account": "Tài khoản",
      "settings": "Cài đặt",
      "logout": "Đăng xuất",
      "tapToAccount": "Nhấn để xem tài khoản",
      "nicknameNotSet": "Chưa thiết lập biệt danh",
      "update": "Cập nhật",

      // Create survey
      "createSurvey": "Tạo khảo sát",
      "surveyName": "Tên khảo sát",
      "surveyNameHint": "Mẫu khảo sát",
      "formDescription": "Mô tả biểu mẫu",
      "untitledQuestion": "Câu hỏi không có tiêu đề",
      "multipleChoice": "Trắc nghiệm",
      "textAnswer": "Văn bản",
      "imageQuestion": "Câu hỏi bằng ảnh",
      "multipleChoiceImage": "Trắc nghiệm có ảnh",
      "option": "Tùy chọn",
      "addOption": "Thêm tùy chọn",
      "required": "Bắt buộc",
      "textAnswerPlaceholder": "Câu trả lời dạng văn bản",
      "questionImagePlaceholder": "Ảnh minh họa câu hỏi",
      "next": "Tiếp theo",
      "pleaseAddQuestion": "Vui lòng thêm ít nhất 1 câu hỏi",

      // Survey setup
      "setupSurvey": "Thiết lập khảo sát",
      "surveyInfo": "Thông tin khảo sát",
      "name": "Tên",
      "description": "Mô tả",
      "noDescription": "Chưa có mô tả",
      "questionCount": "Số câu hỏi",
      "category": "Danh mục khảo sát",
      "start": "Bắt đầu",
      "end": "Kết thúc",
      "notSelected": "Chưa chọn",

      // Reward
      "rewardType": "Loại phần thưởng",
      "rewardValue": "Chọn giá trị phần thưởng",
      "noReward": "Không có",
      "voucher": "Voucher",
      "cash": "Tiền mặt",
      "point": "Điểm tích lũy",
      "customVoucher": "Nhập voucher khác",
      "customCash": "Nhập số tiền khác",
      "customPoint": "Nhập điểm khác",
      "enterVoucher": "Nhập voucher",
      "enterCash": "Nhập số tiền",
      "enterPoint": "Nhập số điểm",
      "voucherHint": "Ví dụ: Voucher giảm 30%",
      "cashHint": "Ví dụ: 30000",
      "pointHint": "Ví dụ: 50",

      // Other survey setup
      "participantLimit": "Giới hạn người tham gia",
      "noLimitHint": "Bỏ trống nếu không giới hạn",
      "previewSurvey": "Xem trước khảo sát",
      "saveDraft": "Lưu bản nháp",
      "finishCreate": "Tạo khảo sát",
      "draftSaved": "Đã lưu bản nháp",
      "createSuccess": "Tạo khảo sát thành công",

      // Profile
      "profile": "Thông tin tài khoản",
      "setupAccount": "Thiết lập tài khoản",
      "changeAvatar": "Đổi ảnh đại diện",
      "nickname": "Biệt danh hiển thị *",
      "nicknameHint": "Ví dụ: Admin Tuấn",
      "fullName": "Họ tên",
      "phone": "Số điện thoại",
      "address": "Địa chỉ",
      "cccd": "CCCD",
      "saveInfo": "Lưu thông tin",
      "notUpdated": "Chưa cập nhật",
      "maskedDisplay": "Hiển thị mã hóa",

      // Settings
      "darkMode": "Chế độ tối",
      "applyWholeApp": "Áp dụng cho toàn bộ ứng dụng",

      // Statistics
      "analysisDashboard": "Dashboard phân tích khảo sát",
      "analysisOption": "Lựa chọn phân tích",
      "overviewAnalysis": "Tổng quan phân tích",
      "responseRate": "Xem tỷ lệ phản hồi khảo sát",
      "anonymousReview": "Xem đánh giá ẩn danh",
    };

    return vi[key] ?? key;
  }
}