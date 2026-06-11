import 'dart:io';
import 'package:flutter/material.dart';
import '../models/khao_sat.dart';
import '../models/cau_hoi.dart';
import '../models/lich_su_khao_sat.dart';
import '../models/chi_tiet_lich_su.dart';
import '../controllers/lich_su_controller.dart';
import '../controllers/khao_sat_controller.dart';
import '../controllers/vi_controller.dart';
import '../models/vi_phan_thuong.dart';
import '../models/account.dart';

class DoSurveyScreen extends StatefulWidget {
  final KhaoSat survey;
  final Account account;

  const DoSurveyScreen({super.key, required this.survey, required this.account});

  @override
  State<DoSurveyScreen> createState() => _DoSurveyScreenState();
}

class _DoSurveyScreenState extends State<DoSurveyScreen> {
  final Map<int, int> _selectedAnswers = {}; // idCauHoi -> idDapAn
  final Map<int, String> _textAnswers = {}; // idCauHoi -> NoiDungTraLoi
  final LichSuController _lichSuController = LichSuController();

  Future<void> _submitSurvey() async {
    // Validate
    bool allAnswered = true;
    for (var cauHoi in widget.survey.cauHois) {
      if (cauHoi.batBuoc) {
        if (cauHoi.loaiCauHoi == LoaiCauHoi.tracNghiem && !_selectedAnswers.containsKey(cauHoi.id)) {
          allAnswered = false;
          break;
        }
        if (cauHoi.loaiCauHoi == LoaiCauHoi.tuLuan && (_textAnswers[cauHoi.id] == null || _textAnswers[cauHoi.id]!.trim().isEmpty)) {
          allAnswered = false;
          break;
        }
      }
    }

    if (!allAnswered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng trả lời đầy đủ các câu hỏi bắt buộc!')),
      );
      return;
    }

    // Save history
    List<ChiTietLichSu> chiTietList = [];
    for (var cauHoi in widget.survey.cauHois) {
      if (cauHoi.loaiCauHoi == LoaiCauHoi.tracNghiem && _selectedAnswers.containsKey(cauHoi.id)) {
        chiTietList.add(ChiTietLichSu(
          idChiTiet: 0,
          idLichSu: 0,
          idCauHoi: cauHoi.id,
          idDapAn: _selectedAnswers[cauHoi.id],
        ));
      } else if (cauHoi.loaiCauHoi == LoaiCauHoi.tuLuan && _textAnswers.containsKey(cauHoi.id)) {
        chiTietList.add(ChiTietLichSu(
          idChiTiet: 0,
          idLichSu: 0,
          idCauHoi: cauHoi.id,
          noiDungTraLoi: _textAnswers[cauHoi.id],
        ));
      }
    }

    LichSuKhaoSat lichSu = LichSuKhaoSat(
      idLichSu: 0,
      idKhaoSat: widget.survey.id,
      idTaiKhoan: widget.account.id ?? 1,
      ngayLam: DateTime.now(),
      chiTietList: chiTietList,
    );

    await _lichSuController.saveLichSu(lichSu);

    // Cập nhật số liệu cho khảo sát
    widget.survey.soHoanThanh++;
    widget.survey.soPhanHoi++;
    widget.survey.soNguoiThamGia++;
    await KhaoSatController().updateSurveyInfoOnly(widget.survey);

    // Lưu phần thưởng nếu có
    String thongBaoThuong = "";
    if (widget.survey.loaiPhanThuong != LoaiPhanThuong.khongCo) {
      ViPhanThuong thuong = ViPhanThuong(
        idTaiKhoan: widget.account.id ?? 1, 
        tenKhaoSat: widget.survey.tenKhaoSat,
        loaiPhanThuong: widget.survey.loaiPhanThuong,
        giaTri: widget.survey.giaTriPhanThuong ?? "Không rõ",
        ngayNhan: DateTime.now(),
      );
      await ViController().addReward(thuong);
      thongBaoThuong = "\n\nBạn đã nhận được: ${widget.survey.getPhanThuongText()}! Hãy kiểm tra trong Ví phần thưởng.";
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Thành công'),
        content: Text('Cảm ơn bạn đã tham gia khảo sát!$thongBaoThuong'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Pop from do_survey
              Navigator.pop(context); // Pop from survey_detail -> back to home
            },
            child: const Text('Về trang chủ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.survey.tenKhaoSat),
        backgroundColor: const Color(0xFF0EA5E9),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: widget.survey.cauHois.length,
        itemBuilder: (context, index) {
          final cauHoi = widget.survey.cauHois[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Câu ${index + 1}: ${cauHoi.noiDung} ${cauHoi.batBuoc ? "(*)" : ""}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (cauHoi.hinhAnh != null) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(cauHoi.hinhAnh!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Text('Lỗi ảnh', style: TextStyle(color: Colors.red)),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  if (cauHoi.loaiCauHoi == LoaiCauHoi.tracNghiem)
                    ...cauHoi.dapAns.map((dapAn) {
                      return RadioListTile<int>(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(dapAn.noiDung),
                            if (dapAn.hinhAnh != null) ...[
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(dapAn.hinhAnh!),
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Text('Lỗi ảnh', style: TextStyle(color: Colors.red)),
                                ),
                              ),
                            ],
                          ],
                        ),
                        value: dapAn.id,
                        groupValue: _selectedAnswers[cauHoi.id],
                        onChanged: (value) {
                          setState(() {
                            _selectedAnswers[cauHoi.id] = value!;
                          });
                        },
                      );
                    }).toList()
                  else
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Nhập câu trả lời...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (value) {
                        _textAnswers[cauHoi.id] = value;
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0EA5E9),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _submitSurvey,
          child: const Text(
            'Nộp bài',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
