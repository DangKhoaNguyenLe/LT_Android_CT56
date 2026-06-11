import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';
import '../models/vi_phan_thuong.dart';
import '../models/khao_sat.dart';

class RewardAdminDetail {
  final int? idVi;
  final int idTaiKhoan;
  final String tenNguoiNhan;
  final String username;
  final String tenKhaoSat;
  final LoaiPhanThuong loaiPhanThuong;
  final String giaTri;
  final DateTime ngayNhan;

  RewardAdminDetail({
    this.idVi,
    required this.idTaiKhoan,
    required this.tenNguoiNhan,
    required this.username,
    required this.tenKhaoSat,
    required this.loaiPhanThuong,
    required this.giaTri,
    required this.ngayNhan,
  });

  factory RewardAdminDetail.fromMap(Map<String, dynamic> map) {
    return RewardAdminDetail(
      idVi: map['idVi'],
      idTaiKhoan: map['idTaiKhoan'],
      tenNguoiNhan: map['HoTen'] ?? map['Username'] ?? 'Không rõ',
      username: map['Username'] ?? '',
      tenKhaoSat: map['tenKhaoSat'],
      loaiPhanThuong: LoaiPhanThuong.values[map['loaiPhanThuong']],
      giaTri: map['giaTri'],
      ngayNhan: DateTime.parse(map['ngayNhan']),
    );
  }
}

class ViController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> _ensureTableExists(Database db) async {
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

  Future<int> addReward(ViPhanThuong viPhanThuong) async {
    final db = await _dbHelper.database;
    await _ensureTableExists(db);
    return await db.insert('ViPhanThuong', viPhanThuong.toMap());
  }

  Future<List<ViPhanThuong>> getRewardsByUser(int idTaiKhoan) async {
    final db = await _dbHelper.database;
    await _ensureTableExists(db);
    final List<Map<String, dynamic>> maps = await db.query(
      'ViPhanThuong',
      where: 'idTaiKhoan = ?',
      whereArgs: [idTaiKhoan],
      orderBy: 'ngayNhan DESC',
    );

    return List.generate(maps.length, (i) {
      return ViPhanThuong.fromMap(maps[i]);
    });
  }

  Future<List<RewardAdminDetail>> getAllRewardsAdmin() async {
    final db = await _dbHelper.database;
    await _ensureTableExists(db);
    
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT v.*, t.HoTen, t.Username 
      FROM ViPhanThuong v 
      LEFT JOIN TaiKhoan t ON v.idTaiKhoan = t.idTaiKhoan 
      ORDER BY v.ngayNhan DESC
    ''');

    return List.generate(maps.length, (i) {
      return RewardAdminDetail.fromMap(maps[i]);
    });
  }

  Future<int> updateRewardAdmin(ViPhanThuong viPhanThuong) async {
    final db = await _dbHelper.database;
    return await db.update(
      'ViPhanThuong',
      viPhanThuong.toMap(),
      where: 'idVi = ?',
      whereArgs: [viPhanThuong.idVi],
    );
  }

  Future<int> deleteRewardAdmin(int idVi) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'ViPhanThuong',
      where: 'idVi = ?',
      whereArgs: [idVi],
    );
  }
}
