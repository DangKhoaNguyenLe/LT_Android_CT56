import 'chi_tiet_lich_su.dart';

class LichSuKhaoSat {
  int idLichSu;
  int idKhaoSat;
  int idTaiKhoan;
  DateTime ngayLam;
  List<ChiTietLichSu> chiTietList;

  LichSuKhaoSat({
    required this.idLichSu,
    required this.idKhaoSat,
    required this.idTaiKhoan,
    required this.ngayLam,
    List<ChiTietLichSu>? chiTietList,
  }) : chiTietList = chiTietList ?? [];

  factory LichSuKhaoSat.fromMap(Map<String, dynamic> map) {
    return LichSuKhaoSat(
      idLichSu: map['idLichSu'],
      idKhaoSat: map['idKhaoSat'],
      idTaiKhoan: map['idTaiKhoan'],
      ngayLam: DateTime.parse(map['NgayLam']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idLichSu': idLichSu == 0 ? null : idLichSu,
      'idKhaoSat': idKhaoSat,
      'idTaiKhoan': idTaiKhoan,
      'NgayLam': ngayLam.toIso8601String(),
    };
  }
}
