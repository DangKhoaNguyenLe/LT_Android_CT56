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
}