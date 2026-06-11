import 'package:flutter/material.dart';

import '../../controllers/khao_sat_controller.dart';
import '../../models/cau_hoi.dart';
import '../../models/khao_sat.dart';
import '../../models/danh_muc.dart';
import '../../models/danh_muc_phan_thuong.dart';
import '../../controllers/danh_muc_phan_thuong_controller.dart';
import '../../utils/app_text.dart';

import 'survey_preview.dart';

class SurveySetupPage extends StatefulWidget {
  final KhaoSat? existingSurvey;
  final String tenKhaoSat;
  final String moTa;
  final List<CauHoi> cauHois;

  const SurveySetupPage({
    super.key,
    this.existingSurvey,
    required this.tenKhaoSat,
    required this.moTa,
    required this.cauHois,
  });

  @override
  State<SurveySetupPage> createState() => _SurveySetupPageState();
}

class _SurveySetupPageState extends State<SurveySetupPage> {
  final KhaoSatController controller = KhaoSatController();
  final DanhMucPhanThuongController _rewardController = DanhMucPhanThuongController();

  List<DanhMuc> danhMucs = [];
  List<DanhMucPhanThuong> rewardTemplates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final list = await controller.getDanhMucList();
    final rewards = await _rewardController.getAll();
    setState(() {
      danhMucs = list;
      rewardTemplates = rewards;
      
      if (widget.existingSurvey != null) {
        ngayBatDau = widget.existingSurvey!.ngayBatDau;
        ngayKetThuc = widget.existingSurvey!.ngayKetThuc;
        if (widget.existingSurvey!.gioiHanNguoiThamGia != null) {
          gioiHanController.text = widget.existingSurvey!.gioiHanNguoiThamGia.toString();
        }
        
        if (widget.existingSurvey!.danhMuc != null) {
          try {
            selectedDanhMuc = danhMucs.firstWhere((dm) => dm.id == widget.existingSurvey!.danhMuc!.id);
          } catch (e) {
            selectedDanhMuc = danhMucs.isNotEmpty ? danhMucs.first : null;
          }
        } else if (danhMucs.isNotEmpty) {
          selectedDanhMuc = danhMucs.first;
        }

        if (widget.existingSurvey!.loaiPhanThuong != LoaiPhanThuong.khongCo) {
          try {
            selectedRewardTemplate = rewardTemplates.firstWhere(
              (r) => r.loaiPhanThuong == widget.existingSurvey!.loaiPhanThuong && 
                     r.giaTri == widget.existingSurvey!.giaTriPhanThuong
            );
          } catch (e) {
            selectedRewardTemplate = null;
          }
        }
      } else if (danhMucs.isNotEmpty) {
        selectedDanhMuc = danhMucs.first;
      }

      isLoading = false;
    });
  }

  final TextEditingController phanThuongController = TextEditingController();
  final TextEditingController gioiHanController = TextEditingController();

  DanhMuc? selectedDanhMuc;
  DanhMucPhanThuong? selectedRewardTemplate;

  DateTime? ngayBatDau;
  DateTime? ngayKetThuc;

  Future<void> pickStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      setState(() {
        ngayBatDau = date;
      });
    }
  }

  Future<void> pickEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: ngayBatDau ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      setState(() {
        ngayKetThuc = date;
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return T.text("notSelected");
    return "${date.day}/${date.month}/${date.year}";
  }

  String getRewardTypeString(LoaiPhanThuong type) {
    switch (type) {
      case LoaiPhanThuong.voucher: return T.text("voucher");
      case LoaiPhanThuong.tienMat: return T.text("cash");
      case LoaiPhanThuong.diemTichLuy: return T.text("point");
      case LoaiPhanThuong.khongCo: return T.text("noReward");
    }
  }

  Future<KhaoSat> buildSurvey(TrangThaiKhaoSat status) async {
    return KhaoSat(
      id: widget.existingSurvey?.id ?? 0,
      tenKhaoSat: widget.tenKhaoSat,
      moTa: widget.moTa,
      ngayTao: widget.existingSurvey?.ngayTao ?? DateTime.now(),
      ngayBatDau: ngayBatDau,
      ngayKetThuc: ngayKetThuc,
      danhMuc: selectedDanhMuc,
      trangThai: status,
      loaiPhanThuong: selectedRewardTemplate?.loaiPhanThuong ?? LoaiPhanThuong.khongCo,
      giaTriPhanThuong: selectedRewardTemplate?.giaTri,
      gioiHanNguoiThamGia: gioiHanController.text.trim().isEmpty
          ? null
          : int.tryParse(gioiHanController.text.trim()),
      cauHois: List.from(widget.cauHois),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> saveDraft() async {
    final survey = await buildSurvey(TrangThaiKhaoSat.banNhap);

    final error = controller.validateSurvey(
      survey,
      isPublish: false,
    );

    if (error != null) {
      showMessage(error);
      return;
    }

    if (widget.existingSurvey != null) {
      await controller.updateSurvey(survey);
      showMessage("Đã cập nhật bản nháp thành công");
    } else {
      await controller.addSurvey(survey);
      showMessage(T.text("draftSaved"));
    }

    if(context.mounted) Navigator.pop(context, true);
  }

  Future<void> publishSurvey() async {
    final survey = await buildSurvey(TrangThaiKhaoSat.dangMo);

    final error = controller.validateSurvey(
      survey,
      isPublish: true,
    );

    if (error != null) {
      showMessage(error);
      return;
    }

    if (widget.existingSurvey != null) {
      await controller.updateSurvey(survey);
      showMessage("Đã cập nhật khảo sát thành công");
    } else {
      await controller.addSurvey(survey);
      showMessage(T.text("createSuccess"));
    }

    if(context.mounted) Navigator.pop(context, true);
  }

  Future<void> previewSurvey() async {
    final survey = await buildSurvey(TrangThaiKhaoSat.banNhap);

    if(context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SurveyPreviewPage(khaoSat: survey),
        ),
      );
    }
  }

  Widget buildSurveyInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              T.text("surveyInfo"),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${T.text("name")}: ${widget.tenKhaoSat}",
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              "${T.text("description")}: ${widget.moTa.isEmpty ? T.text("noDescription") : widget.moTa}",
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              "${T.text("questionCount")}: ${widget.cauHois.length}",
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRewardSection() {
    return Column(
      children: [
        DropdownButtonFormField<DanhMucPhanThuong?>(
          value: selectedRewardTemplate,
          decoration: InputDecoration(
            labelText: T.text("rewardType"),
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem(
              value: null,
              child: Text(T.text("noReward")),
            ),
            ...rewardTemplates.map((template) {
              return DropdownMenuItem(
                value: template,
                child: Text("${template.tenPhanThuong} (${template.giaTri})"),
              );
            }).toList(),
          ],
          onChanged: (value) {
            setState(() {
              selectedRewardTemplate = value;
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ValueListenableBuilder<Locale>(
      valueListenable: T.locale,
      builder: (context, locale, child) {
        return Scaffold(
          
          appBar: AppBar(
            title: Text(T.text("setupSurvey")),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(14),
            children: [
              buildSurveyInfoCard(),

              const SizedBox(height: 12),

              DropdownButtonFormField<DanhMuc?>(
                value: selectedDanhMuc,
                decoration: InputDecoration(
                  labelText: T.text("category"),
                  filled: true,
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(),
                ),
                items: [
                  if (danhMucs.isEmpty)
                    DropdownMenuItem<DanhMuc?>(
                      value: null,
                      child: Text('Không có danh mục'),
                    ),
                  ...danhMucs.map((dm) {
                    return DropdownMenuItem<DanhMuc?>(
                      value: dm,
                      child: Text(dm.tenDanhMuc),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedDanhMuc = value;
                  });
                },
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: pickStartDate,
                      icon: const Icon(Icons.date_range),
                      label: Text("${T.text("start")}: ${formatDate(ngayBatDau)}"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: pickEndDate,
                      icon: const Icon(Icons.event),
                      label: Text("${T.text("end")}: ${formatDate(ngayKetThuc)}"),
                    ),
                  ),
                ],
              ),
              if (ngayKetThuc != null && 
                  DateTime.now().isAfter(DateTime(ngayKetThuc!.year, ngayKetThuc!.month, ngayKetThuc!.day, 23, 59, 59)))
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    "* Lưu ý: Ngày kết thúc đã qua, nếu xuất bản thì khảo sát sẽ hiển thị là 'Đã đóng (Hết hạn)'.",
                    style: TextStyle(color: Colors.red, fontSize: 13, fontStyle: FontStyle.italic),
                  ),
                ),

              const SizedBox(height: 12),

              buildRewardSection(),

              const SizedBox(height: 12),

              TextField(
                controller: gioiHanController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: T.text("participantLimit"),
                  hintText: T.text("noLimitHint"),
                  filled: true,
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              OutlinedButton.icon(
                onPressed: previewSurvey,
                icon: const Icon(Icons.remove_red_eye),
                label: Text(T.text("previewSurvey")),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: saveDraft,
                      child: Text(widget.existingSurvey != null ? "Cập nhật bản nháp" : T.text("saveDraft")),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff08aff0),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: publishSurvey,
                      child: Text(widget.existingSurvey != null ? "Hoàn tất chỉnh sửa" : T.text("finishCreate")),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
