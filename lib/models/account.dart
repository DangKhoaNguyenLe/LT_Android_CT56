class Account {
  final int? id; // id có thể null khi tạo mới
  String username;
  String password;
  String hoTen;
  String ngaySinh;
  int gioiTinh;
  String soDienThoai;
  String email;
  String queQuan;
  String role;

  Account({
    this.id,
    required this.username,
    required this.password,
    required this.hoTen,
    required this.ngaySinh,
    required this.gioiTinh,
    required this.soDienThoai,
    required this.email,
    required this.queQuan,
    required this.role,
  });

  factory Account.SqlMapObject(Map<String, dynamic> map) {
    return Account(
      id: map['idTaiKhoan'],
      username: map['Username'] ?? '',
      password: map['Password'] ?? '',
      hoTen: map['HoTen'] ?? '',
      ngaySinh: map['NgaySinh'] ?? '',
      gioiTinh: map['GioiTinh'] ?? 0,
      soDienThoai: map['SoDienThoai'] ?? '',
      email: map['Email'] ?? '',
      queQuan: map['QueQuan'] ?? '',
      role: map['Role'] ?? 'User',
    );
  }

  Map<String, dynamic> ObjectMapSql() {
    return {
      if (id != null) 'idTaiKhoan': id,
      'Username': username,
      'Password': password,
      'HoTen': hoTen,
      'NgaySinh': ngaySinh,
      'GioiTinh': gioiTinh,
      'SoDienThoai': soDienThoai,
      'Email': email,
      'QueQuan': queQuan,
      'Role': role,
    };
  }
}
