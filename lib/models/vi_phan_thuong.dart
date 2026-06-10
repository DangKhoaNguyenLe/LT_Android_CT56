import 'khao_sat.dart';

class ViPhanThuong {
  int? idVi;
  int idTaiKhoan;
  String tenKhaoSat;
  LoaiPhanThuong loaiPhanThuong;
  String giaTri;
  DateTime ngayNhan;

  ViPhanThuong({
    this.idVi,
    required this.idTaiKhoan,
    required this.tenKhaoSat,
    required this.loaiPhanThuong,
    required this.giaTri,
    required this.ngayNhan,
  });

  Map<String, dynamic> toMap() {
    return {
      'idVi': idVi,
      'idTaiKhoan': idTaiKhoan,
      'tenKhaoSat': tenKhaoSat,
      'loaiPhanThuong': loaiPhanThuong.index,
      'giaTri': giaTri,
      'ngayNhan': ngayNhan.toIso8601String(),
    };
  }

  factory ViPhanThuong.fromMap(Map<String, dynamic> map) {
    return ViPhanThuong(
      idVi: map['idVi'],
      idTaiKhoan: map['idTaiKhoan'],
      tenKhaoSat: map['tenKhaoSat'],
      loaiPhanThuong: LoaiPhanThuong.values[map['loaiPhanThuong']],
      giaTri: map['giaTri'],
      ngayNhan: DateTime.parse(map['ngayNhan']),
    );
  }
}
