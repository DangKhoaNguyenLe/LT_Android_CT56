class Category {
  int? idDanhMuc;
  String ten;
  int? idTaiKhoan;

  Category({
    this.idDanhMuc,
    required this.ten,
    this.idTaiKhoan,
  });

  Map<String, dynamic> toMap() {
    return {
      'idDanhMuc': idDanhMuc,
      'Ten': ten,
      'idTaiKhoan': idTaiKhoan,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      idDanhMuc: map['idDanhMuc'],
      ten: map['Ten'],
      idTaiKhoan: map['idTaiKhoan'],
    );
  }
}
