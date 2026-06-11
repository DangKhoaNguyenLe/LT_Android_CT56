import 'khao_sat.dart';

class RewardAdminDetail {
  final int? idVi;
  final int idTaiKhoan;
  final String tenNguoiNhan;
  final String username;
  final String tenKhaoSat;
  final LoaiPhanThuong loaiPhanThuong;
  final String giaTri;
  final DateTime ngayNhan;

  RewardAdminDetail({
    this.idVi,
    required this.idTaiKhoan,
    required this.tenNguoiNhan,
    required this.username,
    required this.tenKhaoSat,
    required this.loaiPhanThuong,
    required this.giaTri,
    required this.ngayNhan,
  });

  factory RewardAdminDetail.fromMap(Map<String, dynamic> map) {
    return RewardAdminDetail(
      idVi: map['idVi'],
      idTaiKhoan: map['idTaiKhoan'],
      tenNguoiNhan: map['HoTen'] ?? map['Username'] ?? 'Không rõ',
      username: map['Username'] ?? '',
      tenKhaoSat: map['tenKhaoSat'],
      loaiPhanThuong: LoaiPhanThuong.values[map['loaiPhanThuong']],
      giaTri: map['giaTri'],
      ngayNhan: DateTime.parse(map['ngayNhan']),
    );
  }
}
