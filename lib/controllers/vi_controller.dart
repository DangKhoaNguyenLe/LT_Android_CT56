import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';
import '../models/vi_phan_thuong.dart';
import '../models/khao_sat.dart';
import '../models/reward_admin_detail.dart';

class ViController {
  final DatabaseHelper _dbHelper = DatabaseHelper();


  Future<int> addReward(ViPhanThuong viPhanThuong) async {
    final db = await _dbHelper.database;
    return await db.insert('ViPhanThuong', viPhanThuong.toMap());
  }

  Future<List<ViPhanThuong>> getRewardsByUser(int idTaiKhoan) async {
    final db = await _dbHelper.database;
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
