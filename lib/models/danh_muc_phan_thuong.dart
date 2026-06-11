import 'khao_sat.dart';

class DanhMucPhanThuong {
  int? idPhanThuong;
  String tenPhanThuong;
  LoaiPhanThuong loaiPhanThuong;
  String giaTri;

  DanhMucPhanThuong({
    this.idPhanThuong,
    required this.tenPhanThuong,
    required this.loaiPhanThuong,
    required this.giaTri,
  });

  Map<String, dynamic> toMap() {
    return {
      'idPhanThuong': idPhanThuong,
      'tenPhanThuong': tenPhanThuong,
      'loaiPhanThuong': loaiPhanThuong.index,
      'giaTri': giaTri,
    };
  }

  factory DanhMucPhanThuong.fromMap(Map<String, dynamic> map) {
    return DanhMucPhanThuong(
      idPhanThuong: map['idPhanThuong'],
      tenPhanThuong: map['tenPhanThuong'],
      loaiPhanThuong: LoaiPhanThuong.values[map['loaiPhanThuong']],
      giaTri: map['giaTri'],
    );
  }
}
