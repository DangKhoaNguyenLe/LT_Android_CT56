import 'dap_an.dart';

enum LoaiCauHoi {
  tuLuan,
  tracNghiem,
}

class CauHoi {
  int id;
  String noiDung;
  LoaiCauHoi loaiCauHoi;
  bool batBuoc;
  String? hinhAnh;
  List<DapAn> dapAns;

  CauHoi({
    required this.id,
    required this.noiDung,
    required this.loaiCauHoi,
    this.batBuoc = false,
    this.hinhAnh,
    List<DapAn>? dapAns,
  }) : dapAns = dapAns ?? [];

  Map<String, dynamic> toMap(int idKhaoSat) {
    return {
      'idCauHoi': id == 0 ? null : id,
      'idKhaoSat': idKhaoSat,
      'noiDung': noiDung,
      'loaiCauHoi': loaiCauHoi.index,
      'batBuoc': batBuoc ? 1 : 0,
      'hinhAnh': hinhAnh,
    };
  }

  factory CauHoi.fromMap(Map<String, dynamic> map, {List<DapAn>? dapAns}) {
    return CauHoi(
      id: map['idCauHoi'] as int? ?? 0,
      noiDung: map['noiDung'] as String? ?? '',
      loaiCauHoi: LoaiCauHoi.values[map['loaiCauHoi'] as int? ?? 0],
      batBuoc: (map['batBuoc'] as int? ?? 0) == 1,
      hinhAnh: map['hinhAnh'] as String?,
      dapAns: dapAns ?? [],
    );
  }
}