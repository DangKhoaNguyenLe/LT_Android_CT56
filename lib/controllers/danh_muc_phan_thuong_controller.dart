import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';
import '../models/danh_muc_phan_thuong.dart';

class DanhMucPhanThuongController {
  final DatabaseHelper _dbHelper = DatabaseHelper();


  Future<int> addPhanThuong(DanhMucPhanThuong phanThuong) async {
    final db = await _dbHelper.database;
    return await db.insert('DanhMucPhanThuong', phanThuong.toMap());
  }

  Future<List<DanhMucPhanThuong>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('DanhMucPhanThuong');

    return List.generate(maps.length, (i) {
      return DanhMucPhanThuong.fromMap(maps[i]);
    });
  }

  Future<int> updatePhanThuong(DanhMucPhanThuong phanThuong) async {
    final db = await _dbHelper.database;
    return await db.update(
      'DanhMucPhanThuong',
      phanThuong.toMap(),
      where: 'idPhanThuong = ?',
      whereArgs: [phanThuong.idPhanThuong],
    );
  }

  Future<int> deletePhanThuong(int idPhanThuong) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'DanhMucPhanThuong',
      where: 'idPhanThuong = ?',
      whereArgs: [idPhanThuong],
    );
  }
}
