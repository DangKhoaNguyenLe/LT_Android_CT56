import '../models/khao_sat.dart';
import '../models/danh_muc.dart';
import '../models/cau_hoi.dart';
import '../models/dap_an.dart';

class KhaoSatController {
  static final List<DanhMuc> _danhMucs = [
    DanhMuc(id: 1, tenDanhMuc: "Học tập"),
    DanhMuc(id: 2, tenDanhMuc: "Dịch vụ"),
    DanhMuc(id: 3, tenDanhMuc: "Sức khỏe"),
    DanhMuc(id: 4, tenDanhMuc: "Giải trí"),
    DanhMuc(id: 5, tenDanhMuc: "Khác"),
  ];

  // Giả lập tài khoản mới tạo nên ban đầu không có khảo sát nào
  static final List<KhaoSat> _surveys = [];

  List<DanhMuc> getDanhMucList() {
    return _danhMucs;
  }

  List<KhaoSat> getAll() {
    return _surveys;
  }

  List<KhaoSat> getLatestFiveSurveys() {
    final list = List<KhaoSat>.from(_surveys);

    list.sort((a, b) => b.ngayTao.compareTo(a.ngayTao));

    return list.take(5).toList();
  }

  int generateSurveyId() {
    if (_surveys.isEmpty) {
      return 1;
    }

    return _surveys.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  void addSurvey(KhaoSat khaoSat) {
    _surveys.add(khaoSat);
  }

  void updateSurvey(KhaoSat updatedSurvey) {
    final index = _surveys.indexWhere((item) => item.id == updatedSurvey.id);

    if (index != -1) {
      _surveys[index] = updatedSurvey;
    }
  }

  void deleteSurvey(int id) {
    _surveys.removeWhere((item) => item.id == id);
  }

  KhaoSat? getById(int id) {
    try {
      return _surveys.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  List<KhaoSat> searchByName(String keyword) {
    if (keyword.trim().isEmpty) {
      return getLatestFiveSurveys();
    }

    final list = _surveys.where((item) {
      return item.tenKhaoSat
          .toLowerCase()
          .contains(keyword.trim().toLowerCase());
    }).toList();

    list.sort((a, b) => b.ngayTao.compareTo(a.ngayTao));

    return list.take(5).toList();
  }

  List<KhaoSat> searchByMonth(int month) {
    final list = _surveys.where((item) {
      return item.ngayTao.month == month;
    }).toList();

    list.sort((a, b) => b.ngayTao.compareTo(a.ngayTao));

    return list.take(5).toList();
  }

  KhaoSat copySurvey(KhaoSat oldSurvey) {
    final copiedSurvey = KhaoSat(
      id: generateSurveyId(),
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
          id: cauHoi.id,
          noiDung: cauHoi.noiDung,
          loaiCauHoi: cauHoi.loaiCauHoi,
          batBuoc: cauHoi.batBuoc,
          hinhAnh: cauHoi.hinhAnh,
          dapAns: cauHoi.dapAns.map((dapAn) {
            return DapAn(
              id: dapAn.id,
              noiDung: dapAn.noiDung,
            );
          }).toList(),
        );
      }).toList(),
    );

    _surveys.add(copiedSurvey);

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