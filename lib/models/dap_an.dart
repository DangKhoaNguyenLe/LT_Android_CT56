class DapAn {
  int id;
  String noiDung;
  String? hinhAnh;

  DapAn({
    required this.id,
    required this.noiDung,
    this.hinhAnh,
  });

  Map<String, dynamic> toMap(int idCauHoi) {
    return {
      'idDapAn': id == 0 ? null : id,
      'idCauHoi': idCauHoi,
      'noiDung': noiDung,
      'hinhAnh': hinhAnh,
    };
  }

  factory DapAn.fromMap(Map<String, dynamic> map) {
    return DapAn(
      id: map['idDapAn'] as int? ?? 0,
      noiDung: map['noiDung'] as String? ?? '',
      hinhAnh: map['hinhAnh'] as String?,
    );
  }
}