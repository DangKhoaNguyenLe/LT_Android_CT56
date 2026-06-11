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

  bool isClosedByTime() {
    if (ngayKetThuc != null) {
      DateTime endOfEndDate = DateTime(
          ngayKetThuc!.year, ngayKetThuc!.month, ngayKetThuc!.day, 23, 59, 59);
      if (DateTime.now().isAfter(endOfEndDate)) {
        return true;
      }
    }
    return false;
  }

  String getTrangThaiText() {
    if (trangThai == TrangThaiKhaoSat.dangMo &&
        gioiHanNguoiThamGia != null &&
        gioiHanNguoiThamGia! > 0 &&
        soNguoiThamGia >= gioiHanNguoiThamGia!) {
      return "Đã đóng (Đủ SL)";
    }

    if (trangThai == TrangThaiKhaoSat.dangMo && isClosedByTime()) {
      return "Đã đóng (Hết hạn)";
    }

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

  Map<String, dynamic> toMap() {
    return {
      'idKhaoSat': id == 0 ? null : id,
      'tenKhaoSat': tenKhaoSat,
      'moTa': moTa,
      'ngayTao': ngayTao.toIso8601String(),
      'ngayBatDau': ngayBatDau?.toIso8601String(),
      'ngayKetThuc': ngayKetThuc?.toIso8601String(),
      'idDanhMuc': danhMuc?.id,
      'trangThai': trangThai.index,
      'loaiPhanThuong': loaiPhanThuong.index,
      'giaTriPhanThuong': giaTriPhanThuong,
      'gioiHanNguoiThamGia': gioiHanNguoiThamGia,
      'soPhanHoi': soPhanHoi,
      'soHoanThanh': soHoanThanh,
      'danhGiaTrungBinh': danhGiaTrungBinh,
      'soNguoiThamGia': soNguoiThamGia,
      'idTaiKhoan': 1,
    };
  }

  factory KhaoSat.fromMap(Map<String, dynamic> map, {DanhMuc? danhMuc, List<CauHoi>? cauHois}) {
    return KhaoSat(
      id: map['idKhaoSat'] as int? ?? 0,
      tenKhaoSat: map['tenKhaoSat'] as String? ?? '',
      moTa: map['moTa'] as String? ?? '',
      ngayTao: map['ngayTao'] != null ? DateTime.parse(map['ngayTao']) : DateTime.now(),
      ngayBatDau: map['ngayBatDau'] != null ? DateTime.parse(map['ngayBatDau']) : null,
      ngayKetThuc: map['ngayKetThuc'] != null ? DateTime.parse(map['ngayKetThuc']) : null,
      danhMuc: danhMuc,
      trangThai: TrangThaiKhaoSat.values[map['trangThai'] as int? ?? 0],
      loaiPhanThuong: LoaiPhanThuong.values[map['loaiPhanThuong'] as int? ?? 0],
      giaTriPhanThuong: map['giaTriPhanThuong'] as String?,
      gioiHanNguoiThamGia: map['gioiHanNguoiThamGia'] as int?,
      soPhanHoi: map['soPhanHoi'] as int? ?? 0,
      soHoanThanh: map['soHoanThanh'] as int? ?? 0,
      danhGiaTrungBinh: (map['danhGiaTrungBinh'] as num?)?.toDouble() ?? 0.0,
      soNguoiThamGia: map['soNguoiThamGia'] as int? ?? 0,
      cauHois: cauHois ?? [],
    );
  }
}