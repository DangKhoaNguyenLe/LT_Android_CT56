class Question {
  int? idCauHoi;
  String cauHoi;
  int kieuCauHoi; // 1: Radio, 2: Checkbox, 3: Tự luận
  int? idDanhMuc;

  Question({
    this.idCauHoi,
    required this.cauHoi,
    required this.kieuCauHoi,
    this.idDanhMuc,
  });

  Map<String, dynamic> toMap() {
    return {
      'idCauHoi': idCauHoi,
      'CauHoi': cauHoi,
      'KieuCauHoi': kieuCauHoi,
      'idDanhMuc': idDanhMuc,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      idCauHoi: map['idCauHoi'],
      cauHoi: map['CauHoi'],
      kieuCauHoi: map['KieuCauHoi'],
      idDanhMuc: map['idDanhMuc'],
    );
  }
}
