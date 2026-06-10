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
    final tongPhanHoi = getTongSoPhanHoi(surveys);
    final tongHoanThanh = getTongSoHoanThanh(surveys);

    if (tongPhanHoi == 0) {
      return 0;
    }

    return tongHoanThanh / tongPhanHoi * 100;
  }

  double getDanhGiaTrungBinh(List<KhaoSat> surveys) {
    final filteredSurveys = surveys
        .where((item) => item.danhGiaTrungBinh > 0)
        .toList();

    if (filteredSurveys.isEmpty) {
      return 0;
    }

    double total = 0;
    for (final survey in filteredSurveys) {
      total += survey.danhGiaTrungBinh;
    }

    return total / filteredSurveys.length;
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