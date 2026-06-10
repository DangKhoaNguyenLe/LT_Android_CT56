import 'cau_hoi.dart';
import 'danh_muc.dart';

enum TrangThaiKhaoSat {
  banNhap,
  dangMo,
  daDong,
}

enum LoaiPhanThuong {
  khongCo,
  voucher,
  tienMat,
  diemTichLuy,
}

class KhaoSat {
  int id;
  String tenKhaoSat;
  String moTa;
  DateTime ngayTao;
  DateTime? ngayBatDau;
  DateTime? ngayKetThuc;
  DanhMuc? danhMuc;
  TrangThaiKhaoSat trangThai;
  LoaiPhanThuong loaiPhanThuong;
  String? giaTriPhanThuong;
  int? gioiHanNguoiThamGia;
  List<CauHoi> cauHois;

  // Dữ liệu thống kê
  int soPhanHoi;
  int soHoanThanh;
  double danhGiaTrungBinh;

  // Số người tham gia hiện tại
  int soNguoiThamGia;

  KhaoSat({
    required this.id,
    required this.tenKhaoSat,
    required this.moTa,
    required this.ngayTao,
    this.ngayBatDau,
    this.ngayKetThuc,
    this.danhMuc,
    required this.trangThai,
    required this.loaiPhanThuong,
    this.giaTriPhanThuong,
    this.gioiHanNguoiThamGia,
    required this.cauHois,
    this.soPhanHoi = 0,
    this.soHoanThanh = 0,
    this.danhGiaTrungBinh = 0,
    this.soNguoiThamGia = 0,
  });

  String getTrangThaiText() {
    switch (trangThai) {
      case TrangThaiKhaoSat.banNhap:
        return "Bản nháp";

      case TrangThaiKhaoSat.dangMo:
        return "Đang mở";

      case TrangThaiKhaoSat.daDong:
        return "Đã đóng";
    }
  }

  String getPhanThuongText() {
    switch (loaiPhanThuong) {
      case LoaiPhanThuong.khongCo:
        return "Không có";

      case LoaiPhanThuong.voucher:
        return "Voucher: ${giaTriPhanThuong ?? "Chưa nhập"}";

      case LoaiPhanThuong.tienMat:
        return "Tiền mặt: ${giaTriPhanThuong ?? "Chưa nhập"}";

      case LoaiPhanThuong.diemTichLuy:
        return "Điểm tích lũy: ${giaTriPhanThuong ?? "Chưa nhập"}";
    }
  }

  String getThoiGianText() {
    if (ngayBatDau == null && ngayKetThuc == null) {
      return "Chưa thiết lập";
    }

    final batDau = ngayBatDau == null
        ? "Chưa chọn"
        : "${ngayBatDau!.day}/${ngayBatDau!.month}/${ngayBatDau!.year}";

    final ketThuc = ngayKetThuc == null
        ? "Chưa chọn"
        : "${ngayKetThuc!.day}/${ngayKetThuc!.month}/${ngayKetThuc!.year}";

    return "$batDau - $ketThuc";
  }
}