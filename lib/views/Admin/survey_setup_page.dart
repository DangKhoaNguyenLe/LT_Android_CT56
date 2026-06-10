import 'package:flutter/material.dart';

import '../../controllers/khao_sat_controller.dart';
import '../../models/cau_hoi.dart';
import '../../models/khao_sat.dart';
import '../../models/danh_muc.dart';
import '../../utils/app_text.dart';

import 'survey_preview.dart';

class SurveySetupPage extends StatefulWidget {
  final String tenKhaoSat;
  final String moTa;
  final List<CauHoi> cauHois;

  const SurveySetupPage({
    super.key,
    required this.tenKhaoSat,
    required this.moTa,
    required this.cauHois,
  });

  @override
  State<SurveySetupPage> createState() => _SurveySetupPageState();
}

class _SurveySetupPageState extends State<SurveySetupPage> {
  final KhaoSatController controller = KhaoSatController();

  final TextEditingController phanThuongController = TextEditingController();
  final TextEditingController gioiHanController = TextEditingController();

  DanhMuc? selectedDanhMuc;

  LoaiPhanThuong selectedReward = LoaiPhanThuong.khongCo;
  String? selectedRewardValue;
  bool isCustomReward = false;

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

  List<String> getRewardOptions() {
    switch (selectedReward) {
      case LoaiPhanThuong.voucher:
        return [
          "Voucher 10.000đ",
          "Voucher 20.000đ",
          "Voucher 50.000đ",
          "Free shipping voucher",
          T.text("customVoucher"),
        ];

      case LoaiPhanThuong.tienMat:
        return [
          "5.000đ",
          "10.000đ",
          "20.000đ",
          "50.000đ",
          T.text("customCash"),
        ];

      case LoaiPhanThuong.diemTichLuy:
        return [
          "10 points",
          "20 points",
          "50 points",
          "100 points",
          T.text("customPoint"),
        ];

      case LoaiPhanThuong.khongCo:
        return [];
    }
  }

  String getCustomRewardLabel() {
    switch (selectedReward) {
      case LoaiPhanThuong.voucher:
        return T.text("enterVoucher");
      case LoaiPhanThuong.tienMat:
        return T.text("enterCash");
      case LoaiPhanThuong.diemTichLuy:
        return T.text("enterPoint");
      case LoaiPhanThuong.khongCo:
        return T.text("rewardValue");
    }
  }

  String getCustomRewardHint() {
    switch (selectedReward) {
      case LoaiPhanThuong.voucher:
        return T.text("voucherHint");
      case LoaiPhanThuong.tienMat:
        return T.text("cashHint");
      case LoaiPhanThuong.diemTichLuy:
        return T.text("pointHint");
      case LoaiPhanThuong.khongCo:
        return "";
    }
  }

  bool checkIsCustomReward(String? value) {
    return value == T.text("customVoucher") ||
        value == T.text("customCash") ||
        value == T.text("customPoint");
  }

  String? getFinalRewardValue() {
    if (selectedReward == LoaiPhanThuong.khongCo) {
      return null;
    }

    if (isCustomReward) {
      return phanThuongController.text.trim().isEmpty
          ? null
          : phanThuongController.text.trim();
    }

    return selectedRewardValue;
  }

  KhaoSat buildSurvey(TrangThaiKhaoSat status) {
    return KhaoSat(
      id: controller.generateSurveyId(),
      tenKhaoSat: widget.tenKhaoSat,
      moTa: widget.moTa,
      ngayTao: DateTime.now(),
      ngayBatDau: ngayBatDau,
      ngayKetThuc: ngayKetThuc,
      danhMuc: selectedDanhMuc,
      trangThai: status,
      loaiPhanThuong: selectedReward,
      giaTriPhanThuong: getFinalRewardValue(),
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

  void saveDraft() {
    final survey = buildSurvey(TrangThaiKhaoSat.banNhap);

    final error = controller.validateSurvey(
      survey,
      isPublish: false,
    );

    if (error != null) {
      showMessage(error);
      return;
    }

    controller.addSurvey(survey);

    showMessage(T.text("draftSaved"));
    Navigator.pop(context, true);
  }

  void publishSurvey() {
    final survey = buildSurvey(TrangThaiKhaoSat.dangMo);

    final error = controller.validateSurvey(
      survey,
      isPublish: true,
    );

    if (error != null) {
      showMessage(error);
      return;
    }

    controller.addSurvey(survey);

    showMessage(T.text("createSuccess"));
    Navigator.pop(context, true);
  }

  void previewSurvey() {
    final survey = buildSurvey(TrangThaiKhaoSat.banNhap);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SurveyPreviewPage(khaoSat: survey),
      ),
    );
  }

  Widget buildSurveyInfoCard() {
    return Card(
      color: Colors.white,
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
        DropdownButtonFormField<LoaiPhanThuong>(
          value: selectedReward,
          decoration: InputDecoration(
            labelText: T.text("rewardType"),
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem(
              value: LoaiPhanThuong.khongCo,
              child: Text(T.text("noReward")),
            ),
            DropdownMenuItem(
              value: LoaiPhanThuong.voucher,
              child: Text(T.text("voucher")),
            ),
            DropdownMenuItem(
              value: LoaiPhanThuong.tienMat,
              child: Text(T.text("cash")),
            ),
            DropdownMenuItem(
              value: LoaiPhanThuong.diemTichLuy,
              child: Text(T.text("point")),
            ),
          ],
          onChanged: (value) {
            setState(() {
              selectedReward = value!;
              selectedRewardValue = null;
              isCustomReward = false;
              phanThuongController.clear();
            });
          },
        ),

        if (selectedReward != LoaiPhanThuong.khongCo) ...[
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: selectedRewardValue,
            decoration: InputDecoration(
              labelText: T.text("rewardValue"),
              filled: true,
              fillColor: Colors.white,
              border: const OutlineInputBorder(),
            ),
            items: getRewardOptions().map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedRewardValue = value;
                isCustomReward = checkIsCustomReward(value);

                if (isCustomReward) {
                  phanThuongController.clear();
                } else {
                  phanThuongController.text = value ?? "";
                }
              });
            },
          ),

          if (isCustomReward) ...[
            const SizedBox(height: 12),

            TextField(
              controller: phanThuongController,
              keyboardType: selectedReward == LoaiPhanThuong.tienMat ||
                      selectedReward == LoaiPhanThuong.diemTichLuy
                  ? TextInputType.number
                  : TextInputType.text,
              decoration: InputDecoration(
                labelText: getCustomRewardLabel(),
                hintText: getCustomRewardHint(),
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final danhMucs = controller.getDanhMucList();

    return ValueListenableBuilder<Locale>(
      valueListenable: T.locale,
      builder: (context, locale, child) {
        return Scaffold(
          backgroundColor: const Color(0xffd9d9d9),
          appBar: AppBar(
            title: Text(T.text("setupSurvey")),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(14),
            children: [
              buildSurveyInfoCard(),

              const SizedBox(height: 12),

              DropdownButtonFormField<DanhMuc>(
                value: selectedDanhMuc,
                decoration: InputDecoration(
                  labelText: T.text("category"),
                  filled: true,
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(),
                ),
                items: danhMucs.map((dm) {
                  return DropdownMenuItem(
                    value: dm,
                    child: Text(dm.tenDanhMuc),
                  );
                }).toList(),
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
                      child: Text(T.text("saveDraft")),
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
                      child: Text(T.text("finishCreate")),
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
