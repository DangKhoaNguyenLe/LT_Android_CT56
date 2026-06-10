import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';
import '../models/vi_phan_thuong.dart';

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
}
