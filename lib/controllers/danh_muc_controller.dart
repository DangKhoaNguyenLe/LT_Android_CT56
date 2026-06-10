import '../models/danh_muc.dart';
import '../database/db_helper.dart';

class DanhMucController {
  final DatabaseHelper _dbHelper = DatabaseHelper.connection;

  Future<List<DanhMuc>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('DanhMucCauHoi');
    
    if (maps.isEmpty) {
      final defaultList = ["Học tập", "Dịch vụ", "Sức khỏe", "Giải trí", "Khác"];
      for (String name in defaultList) {
        await add(name);
      }
      return await getAll();
    }

    return maps.map((e) => DanhMuc.fromMap(e)).toList();
  }

  Future<void> add(String name) async {
    final db = await _dbHelper.database;
    await db.insert('DanhMucCauHoi', {'Ten': name, 'idTaiKhoan': 1});
  }

  Future<void> update(int id, String newName) async {
    final db = await _dbHelper.database;
    await db.update(
      'DanhMucCauHoi',
      {'Ten': newName},
      where: 'idDanhMuc = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'DanhMucCauHoi',
      where: 'idDanhMuc = ?',
      whereArgs: [id],
    );
  }
}
