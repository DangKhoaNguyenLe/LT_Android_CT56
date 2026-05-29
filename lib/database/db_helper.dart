import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper connection = DatabaseHelper._internal();
  factory DatabaseHelper() => connection;
  DatabaseHelper._internal();

  static Database? Db;

  Future<Database> get database async {
    if (Db != null) return Db!;
    Db = await _initDatabase();
    return Db!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'khao_sat.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _onCreate(Database db, int version) async {
    // 1. Bảng TaiKhoan
    await db.execute('''
      CREATE TABLE TaiKhoan (
          idTaiKhoan INTEGER PRIMARY KEY AUTOINCREMENT,
          Username VARCHAR(255) UNIQUE NOT NULL,
          Password VARCHAR(255) NOT NULL,
          HoTen NVARCHAR(255),
          NgaySinh TEXT, 
          GioiTinh INTEGER,
          SoDienThoai VARCHAR(255),
          Email VARCHAR(255),
          QueQuan NVARCHAR(255),
          Role NVARCHAR(255)
      )
    ''');

    // 2. Bảng DanhMucCauHoi
    await db.execute('''
      CREATE TABLE DanhMucCauHoi (
          idDanhMuc INTEGER PRIMARY KEY AUTOINCREMENT,
          Ten NVARCHAR(255) NOT NULL,
          idTaiKhoan INTEGER,
          FOREIGN KEY (idTaiKhoan) REFERENCES TaiKhoan (idTaiKhoan)
      )
    ''');

    // 3. Bảng CauHoi
    await db.execute('''
      CREATE TABLE CauHoi (
          idCauHoi INTEGER PRIMARY KEY AUTOINCREMENT,
          CauHoi NVARCHAR(255) NOT NULL,
          KieuCauHoi INTEGER, 
          idDanhMuc INTEGER,
          FOREIGN KEY (idDanhMuc) REFERENCES DanhMucCauHoi (idDanhMuc)
      )
    ''');

    // 4. Bảng DapAn
    await db.execute('''
      CREATE TABLE DapAn (
          idDapAn INTEGER PRIMARY KEY AUTOINCREMENT,
          tenDapAn NVARCHAR(255) NOT NULL,
          idCauHoi INTEGER,
          FOREIGN KEY (idCauHoi) REFERENCES CauHoi (idCauHoi) ON DELETE CASCADE
      )
    ''');

    // 5. Bảng KhaoSat
    await db.execute('''
      CREATE TABLE KhaoSat (
          idKhaoSat INTEGER PRIMARY KEY AUTOINCREMENT,
          TieuDe NVARCHAR(255) NOT NULL,
          MoTa NVARCHAR(255),
          CheDo NVARCHAR(255),
          TrangThai INTEGER, 
          ThoiGianMo TEXT,
          ThoiGianDong TEXT,
          idTaiKhoan INTEGER,
          FOREIGN KEY (idTaiKhoan) REFERENCES TaiKhoan (idTaiKhoan)
      )
    ''');

    // 6. Bảng CauHoiKhaoSat (Bảng trung gian n-n)
    await db.execute('''
      CREATE TABLE CauHoiKhaoSat (
          idCauHoi INTEGER,
          idKhaoSat INTEGER,
          Batbuoc INTEGER, 
          PRIMARY KEY (idCauHoi, idKhaoSat),
          FOREIGN KEY (idCauHoi) REFERENCES CauHoi (idCauHoi),
          FOREIGN KEY (idKhaoSat) REFERENCES KhaoSat (idKhaoSat) ON DELETE CASCADE
      )
    ''');

    // 7. Bảng LichSuKhaoSat
    await db.execute('''
      CREATE TABLE LichSuKhaoSat (
          idLichSu INTEGER PRIMARY KEY AUTOINCREMENT,
          idKhaoSat INTEGER,
          NgayLam TEXT,
          idTaiKhoan INTEGER,
          FOREIGN KEY (idKhaoSat) REFERENCES KhaoSat (idKhaoSat),
          FOREIGN KEY (idTaiKhoan) REFERENCES TaiKhoan (idTaiKhoan)
      )
    ''');

    // 8. Bảng ChiTietLichSuKhaoSat
    await db.execute('''
      CREATE TABLE ChiTietLichSuKhaoSat (
          idChiTiet INTEGER PRIMARY KEY AUTOINCREMENT,
          idLichSu INTEGER,
          idCauHoi INTEGER,
          idDapAn INTEGER, 
          NoiDungTraLoi NVARCHAR(255), 
          FOREIGN KEY (idLichSu) REFERENCES LichSuKhaoSat (idLichSu) ON DELETE CASCADE,
          FOREIGN KEY (idCauHoi) REFERENCES CauHoi (idCauHoi),
          FOREIGN KEY (idDapAn) REFERENCES DapAn (idDapAn)
      )
    ''');

    // Chèn dữ liệu mẫu (Tùy chọn) để test đăng nhập
    await db.execute('''
      INSERT INTO TaiKhoan (Username, Password, HoTen, Role)
      VALUES ('admin', '123456', 'Quản trị viên', 'Admin')
    ''');
  }

  // Helper method để đóng DB
  Future close() async {
    final db = await connection.database;
    db.close();
  }

  // Getter cho instance
  static DatabaseHelper get instance => connection;
}
