class ChiTietLichSu {
  int idChiTiet;
  int idLichSu;
  int idCauHoi;
  int? idDapAn; // Có thể null nếu là câu hỏi tự luận
  String? noiDungTraLoi; // Cho câu hỏi tự luận

  ChiTietLichSu({
    required this.idChiTiet,
    required this.idLichSu,
    required this.idCauHoi,
    this.idDapAn,
    this.noiDungTraLoi,
  });

  factory ChiTietLichSu.fromMap(Map<String, dynamic> map) {
    return ChiTietLichSu(
      idChiTiet: map['idChiTiet'],
      idLichSu: map['idLichSu'],
      idCauHoi: map['idCauHoi'],
      idDapAn: map['idDapAn'],
      noiDungTraLoi: map['NoiDungTraLoi'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idChiTiet': idChiTiet == 0 ? null : idChiTiet,
      'idLichSu': idLichSu,
      'idCauHoi': idCauHoi,
      'idDapAn': idDapAn,
      'NoiDungTraLoi': noiDungTraLoi,
    };
  }
}
