# Sơ đồ Cơ sở dữ liệu - Khảo Sát App

Dưới đây là mã nguồn DBML (Database Markup Language) được trích xuất từ cấu trúc SQLite hiện tại của ứng dụng. Bạn có thể copy toàn bộ đoạn mã bên dưới và dán vào trang web **[dbdiagram.io](https://dbdiagram.io/d)** để hệ thống tự động vẽ ra sơ đồ thực thể liên kết (ERD) hoàn chỉnh.

```dbml
// ==========================================
// DBML Schema for Khảo Sát App
// Copy and paste to dbdiagram.io
// ==========================================

Table TaiKhoan {
  idTaiKhoan int [pk, increment]
  Username varchar(255) [unique, not null]
  Password varchar(255) [not null]
  HoTen nvarchar(255)
  NgaySinh text
  GioiTinh int
  SoDienThoai varchar(255)
  Email varchar(255)
  QueQuan nvarchar(255)
  Role nvarchar(255)
}

Table DanhMucCauHoi {
  idDanhMuc int [pk, increment]
  Ten nvarchar(255) [not null]
  idTaiKhoan int [ref: > TaiKhoan.idTaiKhoan]
}

Table KhaoSat {
  idKhaoSat int [pk, increment]
  tenKhaoSat nvarchar(255) [not null]
  moTa nvarchar(255)
  ngayTao text
  ngayBatDau text
  ngayKetThuc text
  idDanhMuc int [ref: > DanhMucCauHoi.idDanhMuc]
  trangThai int
  loaiPhanThuong int
  giaTriPhanThuong nvarchar(255)
  gioiHanNguoiThamGia int
  soPhanHoi int
  soHoanThanh int
  danhGiaTrungBinh real
  soNguoiThamGia int
  idTaiKhoan int [ref: > TaiKhoan.idTaiKhoan]
}

Table CauHoi {
  idCauHoi int [pk, increment]
  idKhaoSat int [ref: > KhaoSat.idKhaoSat]
  noiDung nvarchar(255) [not null]
  loaiCauHoi int
  batBuoc int
  hinhAnh text
}

Table DapAn {
  idDapAn int [pk, increment]
  idCauHoi int [ref: > CauHoi.idCauHoi]
  noiDung nvarchar(255) [not null]
  hinhAnh text
}

Table LichSuKhaoSat {
  idLichSu int [pk, increment]
  idKhaoSat int [ref: > KhaoSat.idKhaoSat]
  idTaiKhoan int [ref: > TaiKhoan.idTaiKhoan]
  NgayLam text
}

Table ChiTietLichSuKhaoSat {
  idChiTiet int [pk, increment]
  idLichSu int [ref: > LichSuKhaoSat.idLichSu]
  idCauHoi int [ref: > CauHoi.idCauHoi]
  idDapAn int [ref: > DapAn.idDapAn]
  NoiDungTraLoi nvarchar(255)
}

Table ViPhanThuong {
  idVi int [pk, increment]
  idTaiKhoan int [ref: > TaiKhoan.idTaiKhoan]
  tenKhaoSat nvarchar(255)
  loaiPhanThuong int
  giaTri nvarchar(255)
  ngayNhan text
}

Table DanhMucPhanThuong {
  idPhanThuong int [pk, increment]
  tenPhanThuong nvarchar(255)
  loaiPhanThuong int
  giaTri nvarchar(255)
}
```

### Các liên kết khóa ngoại chính (Relationships):
- Mỗi `TaiKhoan` có thể tạo nhiều `DanhMucCauHoi` và `KhaoSat`.
- Mỗi `KhaoSat` thuộc về một `DanhMucCauHoi` và bao gồm nhiều `CauHoi`.
- Mỗi `CauHoi` có nhiều `DapAn`.
- `LichSuKhaoSat` liên kết `KhaoSat` với người dùng `TaiKhoan` đã tham gia.
- `ChiTietLichSuKhaoSat` lưu chi tiết câu trả lời nối tới `CauHoi` và `DapAn` tương ứng.
- `ViPhanThuong` lưu trữ phần thưởng thuộc sở hữu của `TaiKhoan`.
- `DanhMucPhanThuong` lưu trữ cấu hình các phần thưởng hệ thống cung cấp.
