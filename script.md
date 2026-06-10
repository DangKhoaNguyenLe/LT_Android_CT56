Thành viên (1) (Khoa): Database, Xác thực & Quản lý tài khoản
Vì đã làm xong login.dart, register.dart, home.dart và main_layout.dart, người này nắm rõ luồng chạy ban đầu của app. Việc tiếp theo cần làm là kết nối dữ liệu thật: 
•	Database & Models: Khởi tạo cấu hình SQLite trong db_helper.dart và viết Model user.dart. 
•	Logic: Viết AuthController.dart (xử lý đăng nhập, đăng ký, đăng xuất) và UserController.dart (cập nhật thông tin cá nhân). 
•	Views: Hoàn thiện nốt trang thông tin cá nhân profile.dart
Thành viên (2) (Thái): Luồng làm khảo sát (Dành cho User)
Nhiệm vụ cốt lõi dành cho người dùng vào ứng dụng để tìm và thực hiện bài khảo sát:
•	Models: Viết cấu trúc dữ liệu cho khảo sát, câu hỏi, đáp án (khao_sat.dart, cau_hoi.dart, dap_an.dart). 
•	Logic: Viết các hàm lấy danh sách khảo sát, lấy chi tiết câu hỏi và lưu câu trả lời (KhaoSatController.dart, CauHoiController.dart, DapAnController.dart). 
•	Views: Làm giao diện danh sách khảo sát (survey_list.dart) , xem trước khảo sát (survey_detail.dart) và giao diện chọn/bấm làm khảo sát (do_survey.dart). 
Thành viên (3) (Tuấn): Luồng tạo và chỉnh sửa khảo sát (Dành cho Admin)
Nhiệm vụ quản lý nội dung khảo sát, đòi hỏi tương tác thêm/xóa/sửa dữ liệu nhiều:
•	Models: Viết model danh mục (danh_muc.dart - phân loại khảo sát). 
•	Views & Logic kết hợp: * Làm tính năng và giao diện quản lý chung của admin (manage_survey.dart). 
o	Xây dựng luồng tạo/sửa khảo sát (create_survey.dart, edit_survey.dart). 
o	Xây dựng luồng quản lý câu hỏi trong khảo sát đó (question_list.dart, add_question.dart, edit_question.dart). 
Thành viên (4) (Phong): Lịch sử, Thống kê & Quản trị hệ thống
Nhiệm vụ xử lý dữ liệu sau khi user làm bài xong và quản trị tổng thể:
•	Models: Viết cấu trúc dữ liệu lưu kết quả (lich_su_khao_sat.dart, chi_tiet_lich_su.dart). 
•	Logic: Viết hàm lưu/tải lịch sử (LichSuController.dart) và hàm tính toán số liệu, tỷ lệ câu trả lời (ThongKeController.dart). 
•	Views:
o	Phía User: Xem lại các bài khảo sát đã làm (history.dart). 
o	Phía Admin: Trang chủ Admin (admin_dashboard.dart) , quản lý danh sách thành viên (manage_user.dart) và hiển thị biểu đồ/số liệu thống kê (statistics.dart). 


## Update 2: 
  + Bỏ trang login_page.dart.
  + Thêm phần quản lý dang mục 
## Update 3:
  + Mỗi khảo sát thì 1 tài khoản chỉ làm 1 lần 

## update 4:
  + Bỏ phần thống kê ở trang chủ user thường
  + Khi đã làm khảo sát xong nó sẽ ẩn đi
  + Trang giao diện người dùng ở menu khi bấm quản lý tài khoản sẽ vào trang profile
  + Chỉnh sửa ở trang giao diện đầu admin bấm vảo các khảo sát không được
  + Cho phép admin chỉnh sửa các tài khoản, xóa tài khoản
  + Khắc phụ phân tích khảo sát hiện chưa ghi nhận được nếu người dùng làm khảo sát xong vào lại không có số liệu
