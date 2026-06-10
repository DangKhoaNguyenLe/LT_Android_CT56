import '../models/khao_sat.dart';
import '../models/danh_muc.dart';
import '../models/cau_hoi.dart';
import '../models/dap_an.dart';

import '../database/db_helper.dart';

class KhaoSatController {
  final DatabaseHelper _dbHelper = DatabaseHelper.connection;

  Future<List<DanhMuc>> getDanhMucList() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('DanhMucCauHoi');
    return maps.map((e) => DanhMuc.fromMap(e)).toList();
  }

  Future<List<KhaoSat>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('KhaoSat');
    List<KhaoSat> result = [];
    for (var map in maps) {
      result.add(await _getFullKhaoSat(map));
    }
    return result;
  }

  Future<KhaoSat> _getFullKhaoSat(Map<String, dynamic> map) async {
    final db = await _dbHelper.database;
    
    // Get DanhMuc
    DanhMuc? danhMuc;
    if (map['idDanhMuc'] != null) {
      final dmMaps = await db.query('DanhMucCauHoi', where: 'idDanhMuc = ?', whereArgs: [map['idDanhMuc']]);
      if (dmMaps.isNotEmpty) danhMuc = DanhMuc.fromMap(dmMaps.first);
    }

    // Get CauHoi
    final chMaps = await db.query('CauHoi', where: 'idKhaoSat = ?', whereArgs: [map['idKhaoSat']]);
    List<CauHoi> cauHois = [];
    for (var chMap in chMaps) {
      // Get DapAn
      final daMaps = await db.query('DapAn', where: 'idCauHoi = ?', whereArgs: [chMap['idCauHoi']]);
      List<DapAn> dapAns = daMaps.map((e) => DapAn.fromMap(e)).toList();
      cauHois.add(CauHoi.fromMap(chMap, dapAns: dapAns));
    }

    return KhaoSat.fromMap(map, danhMuc: danhMuc, cauHois: cauHois);
  }

  Future<List<KhaoSat>> getLatestFiveSurveys() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('KhaoSat', orderBy: 'ngayTao DESC', limit: 5);
    List<KhaoSat> result = [];
    for (var map in maps) {
      result.add(await _getFullKhaoSat(map));
    }
    return result;
  }

  Future<int> generateSurveyId() async {
    // Không dùng hàm này nữa vì id auto increment
    return 0;
  }

  Future<int> addSurvey(KhaoSat khaoSat) async {
    final db = await _dbHelper.database;
    int idKhaoSat = await db.insert('KhaoSat', khaoSat.toMap());

    for (var cauHoi in khaoSat.cauHois) {
      cauHoi.id = 0;
      int idCauHoi = await db.insert('CauHoi', cauHoi.toMap(idKhaoSat));
      for (var dapAn in cauHoi.dapAns) {
        dapAn.id = 0;
        await db.insert('DapAn', dapAn.toMap(idCauHoi));
      }
    }
    return idKhaoSat;
  }

  Future<void> updateSurvey(KhaoSat updatedSurvey) async {
    final db = await _dbHelper.database;
    await db.update('KhaoSat', updatedSurvey.toMap(), where: 'idKhaoSat = ?', whereArgs: [updatedSurvey.id]);

    await db.delete('CauHoi', where: 'idKhaoSat = ?', whereArgs: [updatedSurvey.id]);
    
    for (var cauHoi in updatedSurvey.cauHois) {
      cauHoi.id = 0; 
      int idCauHoi = await db.insert('CauHoi', cauHoi.toMap(updatedSurvey.id));
      for (var dapAn in cauHoi.dapAns) {
        dapAn.id = 0; 
        await db.insert('DapAn', dapAn.toMap(idCauHoi));
      }
    }
  }

  Future<void> updateSurveyInfoOnly(KhaoSat updatedSurvey) async {
    final db = await _dbHelper.database;
    await db.update('KhaoSat', updatedSurvey.toMap(), where: 'idKhaoSat = ?', whereArgs: [updatedSurvey.id]);
  }

  Future<void> deleteSurvey(int id) async {
    final db = await _dbHelper.database;
    await db.delete('KhaoSat', where: 'idKhaoSat = ?', whereArgs: [id]);
  }

  Future<KhaoSat?> getById(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query('KhaoSat', where: 'idKhaoSat = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return await _getFullKhaoSat(maps.first);
    }
    return null;
  }

  Future<List<KhaoSat>> searchByName(String keyword) async {
    if (keyword.trim().isEmpty) return getLatestFiveSurveys();
    final db = await _dbHelper.database;
    final maps = await db.query('KhaoSat', where: 'tenKhaoSat LIKE ?', whereArgs: ['%${keyword.trim()}%'], orderBy: 'ngayTao DESC', limit: 5);
    List<KhaoSat> result = [];
    for (var map in maps) {
      result.add(await _getFullKhaoSat(map));
    }
    return result;
  }

  Future<List<KhaoSat>> searchByMonth(int month) async {
    final db = await _dbHelper.database;
    String monthStr = month < 10 ? '0$month' : '$month';
    final maps = await db.query('KhaoSat', where: "strftime('%m', ngayTao) = ?", whereArgs: [monthStr], orderBy: 'ngayTao DESC', limit: 5);
    List<KhaoSat> result = [];
    for (var map in maps) {
      result.add(await _getFullKhaoSat(map));
    }
    return result;
  }

  Future<KhaoSat> copySurvey(KhaoSat oldSurvey) async {
    final copiedSurvey = KhaoSat(
      id: 0,
      tenKhaoSat: "Bản sao ${oldSurvey.tenKhaoSat}",
      moTa: oldSurvey.moTa,
      ngayTao: DateTime.now(),
      ngayBatDau: oldSurvey.ngayBatDau,
      ngayKetThuc: oldSurvey.ngayKetThuc,
      danhMuc: oldSurvey.danhMuc,
      trangThai: TrangThaiKhaoSat.banNhap,
      loaiPhanThuong: oldSurvey.loaiPhanThuong,
      giaTriPhanThuong: oldSurvey.giaTriPhanThuong,
      gioiHanNguoiThamGia: oldSurvey.gioiHanNguoiThamGia,
      soPhanHoi: 0,
      soHoanThanh: 0,
      danhGiaTrungBinh: 0,
      soNguoiThamGia: oldSurvey.soNguoiThamGia,
      cauHois: oldSurvey.cauHois.map((cauHoi) {
        return CauHoi(
          id: 0,
          noiDung: cauHoi.noiDung,
          loaiCauHoi: cauHoi.loaiCauHoi,
          batBuoc: cauHoi.batBuoc,
          hinhAnh: cauHoi.hinhAnh,
          dapAns: cauHoi.dapAns.map((dapAn) {
            return DapAn(
              id: 0,
              noiDung: dapAn.noiDung,
            );
          }).toList(),
        );
      }).toList(),
    );

    int newId = await addSurvey(copiedSurvey);
    copiedSurvey.id = newId;
    return copiedSurvey;
  }

  String? validateSurvey(KhaoSat khaoSat, {required bool isPublish}) {
    if (khaoSat.tenKhaoSat.trim().isEmpty) {
      return "Vui lòng nhập tên khảo sát";
    }

    if (isPublish) {
      if (khaoSat.danhMuc == null) {
        return "Vui lòng chọn danh mục khảo sát";
      }

      if (khaoSat.cauHois.isEmpty) {
        return "Vui lòng thêm ít nhất 1 câu hỏi";
      }
    }

    if (khaoSat.ngayBatDau != null && khaoSat.ngayKetThuc != null) {
      if (khaoSat.ngayKetThuc!.isBefore(khaoSat.ngayBatDau!)) {
        return "Ngày kết thúc không được nhỏ hơn ngày bắt đầu";
      }
    }

    for (int i = 0; i < khaoSat.cauHois.length; i++) {
      final cauHoi = khaoSat.cauHois[i];

      if (cauHoi.noiDung.trim().isEmpty) {
        return "Vui lòng nhập nội dung câu hỏi ${i + 1}";
      }

      if (cauHoi.loaiCauHoi == LoaiCauHoi.tracNghiem) {
        if (cauHoi.dapAns.isEmpty) {
          return "Câu hỏi ${i + 1} là trắc nghiệm nên phải có đáp án";
        }

        final dapAnHopLe = cauHoi.dapAns.where((dapAn) {
          return dapAn.noiDung.trim().isNotEmpty;
        }).toList();

        if (dapAnHopLe.length < 2) {
          return "Câu hỏi trắc nghiệm ${i + 1} phải có ít nhất 2 đáp án";
        }
      }
    }

    if (khaoSat.loaiPhanThuong != LoaiPhanThuong.khongCo) {
      if (khaoSat.giaTriPhanThuong == null ||
          khaoSat.giaTriPhanThuong!.trim().isEmpty) {
        return "Vui lòng nhập giá trị phần thưởng";
      }
    }

    return null;
  }
}