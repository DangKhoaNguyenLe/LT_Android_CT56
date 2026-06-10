import '../models/lich_su_khao_sat.dart';
import '../models/chi_tiet_lich_su.dart';
import '../database/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class LichSuController {
  final DatabaseHelper _dbHelper = DatabaseHelper.connection;

  Future<void> saveLichSu(LichSuKhaoSat lichSu) async {
    final db = await _dbHelper.database;
    int idLichSu = await db.insert('LichSuKhaoSat', lichSu.toMap());
    
    for(var chiTiet in lichSu.chiTietList) {
      chiTiet.idLichSu = idLichSu;
      await db.insert('ChiTietLichSuKhaoSat', chiTiet.toMap());
    }
  }

  Future<List<LichSuKhaoSat>> getLichSuByUser(int userId) async {
    final db = await _dbHelper.database;
    final maps = await db.query('LichSuKhaoSat', where: 'idTaiKhoan = ?', whereArgs: [userId]);
    List<LichSuKhaoSat> result = [];
    for(var map in maps) {
      result.add(await _getFullLichSu(map));
    }
    return result;
  }

  Future<LichSuKhaoSat> _getFullLichSu(Map<String, dynamic> map) async {
    final db = await _dbHelper.database;
    final chiTietMaps = await db.query('ChiTietLichSuKhaoSat', where: 'idLichSu = ?', whereArgs: [map['idLichSu']]);
    List<ChiTietLichSu> chiTietList = chiTietMaps.map((e) => ChiTietLichSu.fromMap(e)).toList();
    
    return LichSuKhaoSat(
      idLichSu: map['idLichSu'] as int,
      idKhaoSat: map['idKhaoSat'] as int,
      idTaiKhoan: map['idTaiKhoan'] as int,
      ngayLam: DateTime.parse(map['NgayLam']),
      chiTietList: chiTietList,
    );
  }

  Future<bool> hasUserCompletedSurvey(int userId, int surveyId) async {
    final db = await _dbHelper.database;
    final count = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM LichSuKhaoSat WHERE idTaiKhoan = ? AND idKhaoSat = ?',
      [userId, surveyId]
    ));
    return (count ?? 0) > 0;
  }

  Future<List<LichSuKhaoSat>> getAllLichSu() async {
    final db = await _dbHelper.database;
    final maps = await db.query('LichSuKhaoSat');
    List<LichSuKhaoSat> result = [];
    for(var map in maps) {
      result.add(await _getFullLichSu(map));
    }
    return result;
  }
}
