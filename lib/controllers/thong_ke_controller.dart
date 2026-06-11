import 'khao_sat_controller.dart';
import '../models/khao_sat.dart';

class ThongKeController {
  final KhaoSatController khaoSatController = KhaoSatController();

  Future<List<KhaoSat>> getAllSurveys() {
    return khaoSatController.getAll();
  }

  int getTongSoPhanHoi(List<KhaoSat> surveys) {
    int total = 0;
    for (final survey in surveys) {
      total += survey.soPhanHoi;
    }
    return total;
  }

  int getTongSoHoanThanh(List<KhaoSat> surveys) {
    int total = 0;
    for (final survey in surveys) {
      total += survey.soHoanThanh;
    }
    return total;
  }

  double getTiLeHoanThanh(List<KhaoSat> surveys) {
    if (surveys.isEmpty) {
      return 0;
    }
    
    int closedCount = 0;
    for (final survey in surveys) {
      if (survey.trangThai == TrangThaiKhaoSat.daDong || 
          survey.isClosedByTime() || 
          (survey.gioiHanNguoiThamGia != null && survey.gioiHanNguoiThamGia! > 0 && survey.soNguoiThamGia >= survey.gioiHanNguoiThamGia!)) {
        closedCount++;
      }
    }

    return (closedCount / surveys.length) * 100;
  }

  List<KhaoSat> getTopSurveys(List<KhaoSat> surveys, {int limit = 5}) {
    final sorted = List<KhaoSat>.from(surveys);
    sorted.sort((a, b) => b.soPhanHoi.compareTo(a.soPhanHoi));
    return sorted.take(limit).toList();
  }

  int getTongSoKhaoSat(List<KhaoSat> surveys) {
    return surveys.length;
  }

  int getSoKhaoSatDangMo(List<KhaoSat> surveys) {
    return surveys
        .where((item) => item.trangThai == TrangThaiKhaoSat.dangMo)
        .length;
  }

  int getSoKhaoSatBanNhap(List<KhaoSat> surveys) {
    return surveys
        .where((item) => item.trangThai == TrangThaiKhaoSat.banNhap)
        .length;
  }

  int getSoKhaoSatDaDong(List<KhaoSat> surveys) {
    return surveys
        .where((item) => item.trangThai == TrangThaiKhaoSat.daDong)
        .length;
  }

  Map<String, int> getPhanHoiTheoKhaoSat(List<KhaoSat> surveys) {
    final Map<String, int> data = {};
    for (final survey in surveys) {
      data[survey.tenKhaoSat] = survey.soPhanHoi;
    }
    return data;
  }
}