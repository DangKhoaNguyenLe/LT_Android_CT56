import 'package:flutter/material.dart';
import '../../models/khao_sat.dart';
import '../../models/cau_hoi.dart';
import '../../controllers/khao_sat_controller.dart';
import '../../controllers/lich_su_controller.dart';
import '../../models/lich_su_khao_sat.dart';

class SurveyStatisticsDetail extends StatefulWidget {
  final KhaoSat khaoSat;

  const SurveyStatisticsDetail({super.key, required this.khaoSat});

  @override
  State<SurveyStatisticsDetail> createState() => _SurveyStatisticsDetailState();
}

class _SurveyStatisticsDetailState extends State<SurveyStatisticsDetail> {
  final LichSuController _lichSuController = LichSuController();
  List<LichSuKhaoSat> _allLichSu = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final allLichSu = await _lichSuController.getAllLichSu();
    setState(() {
      _allLichSu = allLichSu.where((ls) => ls.idKhaoSat == widget.khaoSat.id).toList();
      _isLoading = false;
    });
  }

  Widget _buildStatisticsContent() {
    if (_allLichSu.isEmpty) {
      return const Center(child: Text("Chưa có lượt nộp bài nào cho khảo sát này."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.khaoSat.cauHois.length,
      itemBuilder: (context, index) {
        final cauHoi = widget.khaoSat.cauHois[index];

        // Lấy tất cả câu trả lời cho câu hỏi này
        final listTraLoi = _allLichSu
            .expand((ls) => ls.chiTietList)
            .where((c) => c.idCauHoi == cauHoi.id)
            .toList();

        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Câu ${index + 1}: ${cauHoi.noiDung}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 12),
                if (cauHoi.loaiCauHoi == LoaiCauHoi.tuLuan)
                  _buildTuLuanStats(listTraLoi)
                else
                  _buildTracNghiemStats(cauHoi, listTraLoi),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTuLuanStats(List<dynamic> listTraLoi) {
    if (listTraLoi.isEmpty) {
      return const Text("Chưa có câu trả lời", style: TextStyle(color: Colors.grey));
    }
    
    // Chỉ hiển thị 5 câu trả lời gần nhất cho tự luận
    final recentAnswers = listTraLoi.take(5).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tổng số phản hồi: ${listTraLoi.length}", style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        const Text("Các câu trả lời gần đây:"),
        const SizedBox(height: 8),
        ...recentAnswers.map((c) {
          final content = c.noiDungTraLoi ?? "(Không có nội dung)";
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(content),
          );
        }),
      ],
    );
  }

  Widget _buildTracNghiemStats(CauHoi cauHoi, List<dynamic> listTraLoi) {
    int totalAnswers = listTraLoi.length;
    
    if (totalAnswers == 0) {
      return const Text("Chưa có câu trả lời", style: TextStyle(color: Colors.grey));
    }

    return Column(
      children: cauHoi.dapAns.map((dapAn) {
        int count = listTraLoi.where((c) => c.idDapAn == dapAn.id).length;
        double percentage = (count / totalAnswers) * 100;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      dapAn.noiDung,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                  Text(
                    "$count chọn (${percentage.toStringAsFixed(1)}%)",
                    style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF0EA5E9)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: count / totalAnswers,
                backgroundColor: Colors.grey[200],
                color: const Color(0xFF0EA5E9),
                minHeight: 8,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd9d9d9),
      appBar: AppBar(
        title: const Text("Phân tích chi tiết"),
        backgroundColor: const Color(0xff08aff0),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildStatisticsContent(),
    );
  }
}
