import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';
import '../models/account.dart';

class AuthController {
  final DatabaseHelper _dbHelper = DatabaseHelper.connection;

  Future<Account?> login(String account, String password) async {
    try {
      final db = await _dbHelper.database;

      final List<Map<String, dynamic>> maps = await db.query(
        'TaiKhoan',
        where: '(Email = ? OR Username = ?) AND Password = ?',
        whereArgs: [account, account, password],
      );

      if (maps.isNotEmpty) {
        return Account.SqlMapObject(maps.first);
      }
      return null;
    } catch (e) {
      print("Lỗi đăng nhập: $e");
      return null;
    }
  }

  Future<bool> register(Account account) async {
    try {
      final db = await _dbHelper.database;

      final List<Map<String, dynamic>> isEmail = await db.query(
        'TaiKhoan',
        where: 'Email = ?',
        whereArgs: [account.email],
      );

      if (isEmail.isNotEmpty) {
        return false;
      }
      int result = await db.insert(
        'TaiKhoan',
        account.ObjectMapSql(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return result > 0;
    } catch (e) {
      print("Lỗi đăng ký: $e");
      return false;
    }
  }
}
