# Mô tả:
## Tính năng của Admin (Doanh nghiệp)
- **Quản lý Tài khoản:** Đăng nhập, đăng xuất, cập nhật thông tin cá nhân.
- **Quản lý Danh mục:** Tạo, xem, sửa, xóa các danh mục câu hỏi (dựa trên bảng DanhMucCauHoi).
- **Quản lý Ngân hàng Câu hỏi:** Thêm, xem, sửa, xóa câu hỏi. Hỗ trợ nhiều kiểu câu hỏi (Radio, Checkbox, Tự luận) và quản lý đáp án tương ứng (dựa trên bảng CauHoi, DapAn).
- **Quản lý Khảo sát:** 
  - Tạo đợt khảo sát mới (Tên, Mô tả, Chế độ).
  - Cài đặt thời gian mở/đóng và trạng thái khảo sát.
  - Chọn câu hỏi từ ngân hàng đưa vào khảo sát và thiết lập tính bắt buộc (dựa trên bảng KhaoSat, CauHoiKhaoSat).
- **Thống kê & Báo cáo:** Xem danh sách những người đã tham gia, xem chi tiết các đáp án họ đã chọn, xuất dữ liệu thống kê (dựa trên bảng LichSuKhaoSat, ChiTietLichSuKhaoSat).

## Tính năng của Người dùng (Khách hàng / Nhân viên)
- **Quản lý Tài khoản:** Đăng nhập, đăng ký, chỉnh sửa hồ sơ cá nhân.
- **Danh sách Khảo sát:** Xem danh sách các khảo sát khả dụng (đang trong thời gian mở và trạng thái active).
- **Thực hiện Khảo sát:** 
  - Tham gia trả lời các câu hỏi trong khảo sát.
  - Hệ thống tự động kiểm tra các câu hỏi bắt buộc trước khi cho phép nộp bài.
- **Lịch sử Khảo sát:** Xem lại lịch sử những bài khảo sát mình đã thực hiện. 

# Cấu trúc thư mục:
- **Sử dụng mô hình MVC:**
    lib/
    ├── main.dart
    ├── database/
    │   └── db_helper.dart
    ├── models/
    │   ├── account.dart
    │   ├── survey.dart
    │   ├── category.dart
    │   ├── question.dart
    │   ├── answer.dart
    │   ├── history.dart
    │   └── history_detail.dart
    ├── views/
    │   ├── login.dart
    │   ├── register.dart
    │   ├── Admin/              #Dành cho admin
    │   │   ├── 
    ├── controllers/

 - dp_helper: chứa câu lệnh tạo bảng SQLLite


