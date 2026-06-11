# Ung dung Khao sat (Survey App)

Mot ung dung khao sat toan dien duoc xay dung bang Flutter va su dung co so du lieu SQLite (sqflite). Ung dung cung cap cac tinh nang quan ly khao sat tu phia quan tri vien (Admin) va cho phep nguoi dung (User) tham gia thuc hien khao sat de nhan phan thuong.

---

## Chuc nang chinh

He thong duoc phan quyen voi 2 doi tuong chinh:

### 1. Danh cho Admin (Quan tri vien / Doanh nghiep)
- Quan ly Tai khoan & Quyen: 
  - Xem danh sach, cap nhat, chinh sua thong tin nguoi dung (Ho ten, Mat khau, SDT, Ngay sinh, v.v.).
  - Phan quyen User / Admin.
- Quan ly Danh muc: Phan loai cac bai khao sat theo tung nhom cu the (dua tren bang DanhMucCauHoi).
- Quan ly Ngan hang Cau hoi: 
  - Ho tro da dang loai cau hoi: Trac nghiem 1 lua chon (Radio), Trac nghiem nhieu lua chon (Checkbox) va Tu luan (Essay).
  - Quan ly cac dap an tuong ung.
- Quan ly Khao sat (Surveys):
  - Tao dot khao sat moi: Thiet lap Ten, Mo ta, Thoi gian mo/ket thuc.
  - Gioi han so luong: Cai dat gioi han nguoi tham gia. He thong se tu dong khoa khao sat va chuyen trang thai "Da dong (Du SL)" khi dat chi tieu.
  - Quan ly Phan thuong: Cai dat phan thuong (Coin, Voucher) cho nguoi dung hoan thanh khao sat.
- Thong ke & Bao cao: 
  - Theo doi so luong nguoi tham gia theo thoi gian thuc.
  - Xem chi tiet lich su va cac dap an ma nguoi dung da chon.

### 2. Danh cho Nguoi dung (User / Khach hang)
- Ho so Ca nhan: Dang ky, dang nhap va quan ly thong tin ca nhan (Su dung hop thoai DatePicker tien loi).
- Thuc hien Khao sat:
  - Xem danh sach cac bai khao sat kha dung (Dang mo, Chua het so luong, Chua thuc hien).
  - Tra loi cau hoi. He thong tich hop logic tu dong bat loi neu bo trong cac cau hoi bat buoc.
- Vi Phan thuong (Wallet): Theo doi so diem/phan thuong (Coin) da tich luy sau moi lan hoan thanh khao sat.
- Lich su Khao sat: Tra cuu lai nhung bai khao sat ban than da tham gia va xem lai phan hoi cua chinh minh.

---

## Cau truc du an

Du an ap dung chat che mo hinh MVC (Model - View - Controller) de dam bao code gon gang, de bao tri va mo rong. Duoi day la cau truc thu muc chi tiet cua du an:

```text
lib/
├── main.dart                      # Diem bat dau cua ung dung
├── database/
│   └── db_helper.dart             # Khoi tao ket noi va cac bang SQLite (sqflite)
├── models/                        # Chua cac lop doi tuong (Classes) tuong tac voi co so du lieu
│   ├── account.dart               # Tai khoan nguoi dung
│   ├── khao_sat.dart              # Khao sat
│   ├── cau_hoi.dart               # Cau hoi
│   ├── dap_an.dart                # Dap an
│   ├── danh_muc.dart              # Danh muc khao sat
│   ├── lich_su.dart               # Lich su tham gia
│   └── vi_phan_thuong.dart        # Phan thuong tich luy cua tung user
├── controllers/                   # Xu ly logic nghiep vu, tuong tac giua Models va Views
│   ├── AuthController.dart        # Logic Dang nhap / Dang ky
│   ├── UserController.dart        # Logic cap nhat thong tin nguoi dung
│   ├── khao_sat_controller.dart   # Logic quan ly cac ky Khao sat, Cau hoi, Dap an
│   ├── lich_su_controller.dart    # Logic ghi nhan, truy xuat va thong ke lich su lam khao sat
│   └── vi_controller.dart         # Logic quan ly quy doi va tich luy diem thuong
├── views/                         # Chua cac man hinh giao dien
│   ├── login.dart                 # Man hinh Dang nhap
│   ├── regisiter.dart             # Man hinh Dang ky
│   ├── home.dart                  # Trang chu nguoi dung (Danh sach khao sat)
│   ├── profile.dart               # Quan ly Ho so ca nhan (User)
│   ├── wallet.dart                # Quan ly Vi phan thuong (User)
│   ├── do_survey.dart             # Giao dien thuc hien tra loi khao sat (User)
│   ├── history.dart               # Giao dien xem lich su khao sat (User)
│   ├── history_detail.dart        # Chi tiet cac dap an da chon trong qua khu (User)
│   ├── main_layout.dart           # Layout chinh chua Navigation Bar
│   ├── widgets/                   # Cac thanh phan UI tai su dung (Components)
│   │   ├── custom_app_bar.dart
│   │   ├── custom_bottom_nav.dart
│   │   └── custom_drawer.dart
│   └── Admin/                     # Nhom cac chuc nang rieng cua Quan tri vien
│       ├── admin_dashboard.dart         # Trang chu Admin (Tong quan he thong)
│       ├── manage_user.dart             # Quan ly danh sach nguoi dung
│       ├── manage_category.dart         # Quan ly danh muc
│       ├── manage_survey.dart           # Quan ly danh sach khao sat (CRUD khao sat)
│       ├── create_survey.dart           # Tao khao sat moi
│       ├── edit_survey.dart             # Chinh sua thong tin khao sat
│       ├── question_list.dart           # Quan ly danh sach cau hoi cua 1 khao sat
│       ├── add_question.dart            # Them cau hoi (Radio, Checkbox, Tu luan)
│       ├── edit_question.dart           # Sua cau hoi
│       ├── survey_preview.dart          # Man hinh cho phep Admin xem thu khao sat
│       ├── survey_setup_page.dart       # Cai dat thong so cho khao sat
│       ├── manage_reward.dart           # Quan ly phan thuong tich luy
│       ├── statistics.dart              # Danh sach khao sat de xem thong ke
│       ├── survey_statistics_detail.dart# Chi tiet thong ke theo tung khao sat
│       ├── profile_page.dart            # Quan ly ho so Admin
│       └── setting_page.dart            # Cai dat he thong chung
```

---

## Cong nghe su dung
- Framework: Flutter (Dart)
- Database: SQLite (sqflite) su dung cho local database.
- Ho tro da nen tang bao gom: Android, iOS, va Desktop (Windows/MacOS/Linux thong qua sqflite_common_ffi).

---

## Huong dan chay du an

1. Dam bao ban da cai dat Flutter SDK va cau hinh moi truong gia lap (Android Emulator / iOS Simulator / Desktop).
2. Clone repository nay ve may tinh.
3. Mo Terminal (macOS/Linux) hoac Command Prompt/PowerShell (Windows) tai thu muc goc cua du an va chay:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```
(Luu y: He thong se tu dong khoi tao co so du lieu SQLite ngay trong lan chay dau tien thong qua lop DatabaseHelper.)
