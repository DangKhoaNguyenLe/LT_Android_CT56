import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';
import '../models/account.dart';

class UserController {
  final DatabaseHelper _dbHelper = DatabaseHelper.connection;

  // Cập nhật thông tin cá nhân
  Future<bool> updateUserInfo(Account account) async {
    if (account.id == null) return false;

    try {
      final db = await _dbHelper.database;

      int result = await db.update(
        'TaiKhoan',
        account.ObjectMapSql(),
        where: 'idTaiKhoan = ?',
        whereArgs: [account.id],
      );

      return result > 0;
    } catch (e) {
      print("Lỗi cập nhật thông tin: $e");
      return false;
    }
  }

  // Lấy thông tin tài khoản theo ID
  Future<Account?> getUserById(int id) async {
    try {
      final db = await _dbHelper.database;

      final List<Map<String, dynamic>> maps = await db.query(
        'TaiKhoan',
        where: 'idTaiKhoan = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return Account.SqlMapObject(maps.first);
      }
      return null;
    } catch (e) {
      print("Lỗi lấy thông tin user: $e");
      return null;
    }
  }
}
