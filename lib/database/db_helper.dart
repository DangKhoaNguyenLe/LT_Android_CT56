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
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
      onOpen: (db) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS ViPhanThuong (
              idVi INTEGER PRIMARY KEY AUTOINCREMENT,
              idTaiKhoan INTEGER,
              tenKhaoSat NVARCHAR(255),
              loaiPhanThuong INTEGER,
              giaTri NVARCHAR(255),
              ngayNhan TEXT,
              FOREIGN KEY (idTaiKhoan) REFERENCES TaiKhoan (idTaiKhoan) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS ChiTietLichSuKhaoSat');
      await db.execute('DROP TABLE IF EXISTS LichSuKhaoSat');
      await db.execute('DROP TABLE IF EXISTS CauHoiKhaoSat');
      await db.execute('DROP TABLE IF EXISTS DapAn');
      await db.execute('DROP TABLE IF EXISTS CauHoi');
      await db.execute('DROP TABLE IF EXISTS KhaoSat');
      await db.execute('DROP TABLE IF EXISTS DanhMucCauHoi');
      await db.execute('DROP TABLE IF EXISTS TaiKhoan');
      await _onCreate(db, newVersion);
    } else if (oldVersion < 4) {
      // Đảm bảo tạo bảng nếu các phiên bản trước bị lỗi
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ViPhanThuong (
            idVi INTEGER PRIMARY KEY AUTOINCREMENT,
            idTaiKhoan INTEGER,
            tenKhaoSat NVARCHAR(255),
            loaiPhanThuong INTEGER,
            giaTri NVARCHAR(255),
            ngayNhan TEXT,
            FOREIGN KEY (idTaiKhoan) REFERENCES TaiKhoan (idTaiKhoan) ON DELETE CASCADE
        )
      ''');
    }
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

    // 3. KhaoSat
    await db.execute('''
      CREATE TABLE KhaoSat (
          idKhaoSat INTEGER PRIMARY KEY AUTOINCREMENT,
          tenKhaoSat NVARCHAR(255) NOT NULL,
          moTa NVARCHAR(255),
          ngayTao TEXT,
          ngayBatDau TEXT,
          ngayKetThuc TEXT,
          idDanhMuc INTEGER,
          trangThai INTEGER, 
          loaiPhanThuong INTEGER,
          giaTriPhanThuong NVARCHAR(255),
          gioiHanNguoiThamGia INTEGER,
          soPhanHoi INTEGER,
          soHoanThanh INTEGER,
          danhGiaTrungBinh REAL,
          soNguoiThamGia INTEGER,
          idTaiKhoan INTEGER,
          FOREIGN KEY (idTaiKhoan) REFERENCES TaiKhoan (idTaiKhoan),
          FOREIGN KEY (idDanhMuc) REFERENCES DanhMucCauHoi (idDanhMuc)
      )
    ''');

    // 4. CauHoi
    await db.execute('''
      CREATE TABLE CauHoi (
          idCauHoi INTEGER PRIMARY KEY AUTOINCREMENT,
          idKhaoSat INTEGER,
          noiDung NVARCHAR(255) NOT NULL,
          loaiCauHoi INTEGER, 
          batBuoc INTEGER,
          hinhAnh TEXT,
          FOREIGN KEY (idKhaoSat) REFERENCES KhaoSat (idKhaoSat) ON DELETE CASCADE
      )
    ''');

    // 5. DapAn
    await db.execute('''
      CREATE TABLE DapAn (
          idDapAn INTEGER PRIMARY KEY AUTOINCREMENT,
          idCauHoi INTEGER,
          noiDung NVARCHAR(255) NOT NULL,
          hinhAnh TEXT,
          FOREIGN KEY (idCauHoi) REFERENCES CauHoi (idCauHoi) ON DELETE CASCADE
      )
    ''');

    // 6. LichSuKhaoSat
    await db.execute('''
      CREATE TABLE LichSuKhaoSat (
          idLichSu INTEGER PRIMARY KEY AUTOINCREMENT,
          idKhaoSat INTEGER,
          idTaiKhoan INTEGER,
          NgayLam TEXT,
          FOREIGN KEY (idKhaoSat) REFERENCES KhaoSat (idKhaoSat) ON DELETE CASCADE,
          FOREIGN KEY (idTaiKhoan) REFERENCES TaiKhoan (idTaiKhoan) ON DELETE CASCADE
      )
    ''');

    // 7. ChiTietLichSuKhaoSat
    await db.execute('''
      CREATE TABLE ChiTietLichSuKhaoSat (
          idChiTiet INTEGER PRIMARY KEY AUTOINCREMENT,
          idLichSu INTEGER,
          idCauHoi INTEGER,
          idDapAn INTEGER, 
          NoiDungTraLoi NVARCHAR(255), 
          FOREIGN KEY (idLichSu) REFERENCES LichSuKhaoSat (idLichSu) ON DELETE CASCADE,
          FOREIGN KEY (idCauHoi) REFERENCES CauHoi (idCauHoi) ON DELETE CASCADE,
          FOREIGN KEY (idDapAn) REFERENCES DapAn (idDapAn) ON DELETE CASCADE
      )
    ''');

    // 8. ViPhanThuong
    await db.execute('''
      CREATE TABLE ViPhanThuong (
          idVi INTEGER PRIMARY KEY AUTOINCREMENT,
          idTaiKhoan INTEGER,
          tenKhaoSat NVARCHAR(255),
          loaiPhanThuong INTEGER,
          giaTri NVARCHAR(255),
          ngayNhan TEXT,
          FOREIGN KEY (idTaiKhoan) REFERENCES TaiKhoan (idTaiKhoan) ON DELETE CASCADE
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
