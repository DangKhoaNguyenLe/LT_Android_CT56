class DanhMuc {
  int id;
  String tenDanhMuc;

  DanhMuc({
    required this.id,
    required this.tenDanhMuc,
  });

  Map<String, dynamic> toMap() {
    return {
      'idDanhMuc': id == 0 ? null : id,
      'Ten': tenDanhMuc,
      'idTaiKhoan': 1, 
    };
  }

  factory DanhMuc.fromMap(Map<String, dynamic> map) {
    return DanhMuc(
      id: map['idDanhMuc'] as int? ?? 0,
      tenDanhMuc: map['Ten'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DanhMuc && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}