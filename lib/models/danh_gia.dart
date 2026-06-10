class DanhGia {
  int id;
  String tenNguoiDanhGia;
  String noiDung;
  int soSao;
  DateTime ngayDanhGia;

  DanhGia({
    required this.id,
    required this.tenNguoiDanhGia,
    required this.noiDung,
    required this.soSao,
    required this.ngayDanhGia,
  });

  String getTenAnDanh() {
    return "Người dùng ẩn danh";
  }
}