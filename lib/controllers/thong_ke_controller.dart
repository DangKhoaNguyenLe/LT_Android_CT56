import 'khao_sat_controller.dart';
import '../models/khao_sat.dart';

class ThongKeController {
  final KhaoSatController khaoSatController = KhaoSatController();

  List<KhaoSat> getAllSurveys() {
    return khaoSatController.getAll();
  }

  int getTongSoPhanHoi() {
    int total = 0;

    for (final survey in getAllSurveys()) {
      total += survey.soPhanHoi;
    }

    return total;
  }

  int getTongSoHoanThanh() {
    int total = 0;

    for (final survey in getAllSurveys()) {
      total += survey.soHoanThanh;
    }

    return total;
  }

  double getTiLeHoanThanh() {
    final tongPhanHoi = getTongSoPhanHoi();
    final tongHoanThanh = getTongSoHoanThanh();

    if (tongPhanHoi == 0) {
      return 0;
    }

    return tongHoanThanh / tongPhanHoi * 100;
  }

  double getDanhGiaTrungBinh() {
    final surveys = getAllSurveys()
        .where((item) => item.danhGiaTrungBinh > 0)
        .toList();

    if (surveys.isEmpty) {
      return 0;
    }

    double total = 0;

    for (final survey in surveys) {
      total += survey.danhGiaTrungBinh;
    }

    return total / surveys.length;
  }

  int getTongSoKhaoSat() {
    return getAllSurveys().length;
  }

  int getSoKhaoSatDangMo() {
    return getAllSurveys()
        .where((item) => item.trangThai == TrangThaiKhaoSat.dangMo)
        .length;
  }

  int getSoKhaoSatBanNhap() {
    return getAllSurveys()
        .where((item) => item.trangThai == TrangThaiKhaoSat.banNhap)
        .length;
  }

  int getSoKhaoSatDaDong() {
    return getAllSurveys()
        .where((item) => item.trangThai == TrangThaiKhaoSat.daDong)
        .length;
  }

  Map<String, int> getPhanHoiTheoKhaoSat() {
    final Map<String, int> data = {};

    for (final survey in getAllSurveys()) {
      data[survey.tenKhaoSat] = survey.soPhanHoi;
    }

    return data;
  }
}