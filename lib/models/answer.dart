class Answer {
  int? idDapAn;
  String tenDapAn;
  int? idCauHoi;

  Answer({
    this.idDapAn,
    required this.tenDapAn,
    this.idCauHoi,
  });

  Map<String, dynamic> toMap() {
    return {
      'idDapAn': idDapAn,
      'tenDapAn': tenDapAn,
      'idCauHoi': idCauHoi,
    };
  }

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      idDapAn: map['idDapAn'],
      tenDapAn: map['tenDapAn'],
      idCauHoi: map['idCauHoi'],
    );
  }
}
