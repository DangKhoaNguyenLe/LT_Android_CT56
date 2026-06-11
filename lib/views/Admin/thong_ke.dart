import 'package:flutter/material.dart';

import '../../controllers/thong_ke_controller.dart';
import '../../models/khao_sat.dart';
import 'chi_tiet_thong_ke_khao_sat.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final ThongKeController controller = ThongKeController();

  String selectedMode = "Tổng quan phân tích";
  List<KhaoSat> surveys = [];
  bool isLoading = true;

  final List<String> modes = [
    "Tổng quan phân tích",
    "Xem tỷ lệ phản hồi khảo sát",
    "Xem chi tiết từng khảo sát",
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final fetched = await controller.getAllSurveys();
    setState(() {
      surveys = fetched;
      isLoading = false;
    });
  }

  Widget buildSummaryCard({
    required String title,
    required IconData icon,
    required String value,
  }) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Icon(
              icon,
              color: Colors.grey,
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBreakdown() {
    int dangMo = 0;
    int daDong = 0;
    int banNhap = 0;
    for (var s in surveys) {
      if (s.trangThai == TrangThaiKhaoSat.banNhap) {
        banNhap++;
      } else if (s.trangThai == TrangThaiKhaoSat.daDong || s.isClosedByTime() || (s.gioiHanNguoiThamGia != null && s.gioiHanNguoiThamGia! > 0 && s.soNguoiThamGia >= s.gioiHanNguoiThamGia!)) {
        daDong++;
      } else {
        dangMo++;
      }
    }

    if (surveys.isEmpty) return const SizedBox();

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              if (dangMo > 0) Expanded(flex: dangMo, child: Container(height: 12, color: const Color(0xff08aff0))),
              if (daDong > 0) Expanded(flex: daDong, child: Container(height: 12, color: Colors.grey)),
              if (banNhap > 0) Expanded(flex: banNhap, child: Container(height: 12, color: Colors.orange)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Đang mở: $dangMo", style: const TextStyle(color: Color(0xff08aff0), fontWeight: FontWeight.bold)),
            Text("Đã đóng: $daDong", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            Text("Bản nháp: $banNhap", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }

  Widget _buildTopSurveys() {
    final topSurveys = controller.getTopSurveys(surveys);
    if (topSurveys.isEmpty) return const Text("Chưa có khảo sát nào.");

    return Column(
      children: topSurveys.map((s) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: const CircleAvatar(backgroundColor: Color(0xff08aff0), child: Icon(Icons.star, color: Colors.white)),
          title: Text(s.tenKhaoSat, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Phản hồi: ${s.soPhanHoi} | Lượt tham gia: ${s.soNguoiThamGia}"),
        ),
      )).toList(),
    );
  }

  Widget buildOverview() {
    final tongKhaoSat = surveys.length;
    final tongPhanHoi = controller.getTongSoPhanHoi(surveys);
    
    int dangMoCount = 0;
    for (var s in surveys) {
      if (s.trangThai == TrangThaiKhaoSat.dangMo && !s.isClosedByTime() && !(s.gioiHanNguoiThamGia != null && s.gioiHanNguoiThamGia! > 0 && s.soNguoiThamGia >= s.gioiHanNguoiThamGia!)) {
        dangMoCount++;
      }
    }

    final tiLeHoanThanh = controller.getTiLeHoanThanh(surveys);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            buildSummaryCard(
              title: "Tổng số khảo sát",
              icon: Icons.library_books,
              value: tongKhaoSat.toString(),
            ),
            buildSummaryCard(
              title: "Tổng số phản hồi",
              icon: Icons.groups,
              value: tongPhanHoi.toString(),
            ),
            buildSummaryCard(
              title: "Khảo sát đang mở",
              icon: Icons.play_circle_outline,
              value: dangMoCount.toString(),
            ),
            buildSummaryCard(
              title: "Tỉ lệ hoàn tất",
              icon: Icons.trending_up,
              value: "${tiLeHoanThanh.toStringAsFixed(1)}%",
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text("Trạng thái khảo sát", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildStatusBreakdown(),
        const SizedBox(height: 24),
        const Text("Top khảo sát nhiều tương tác nhất", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildTopSurveys(),
      ],
    );
  }

  Widget buildResponseRate() {
    final data = controller.getPhanHoiTheoKhaoSat(surveys);

    if (data.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Chưa có dữ liệu phản hồi",
            style: TextStyle(fontSize: 15),
          ),
        ),
      );
    }

    final maxValue = data.values.reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Số phản hồi theo từng khảo sát",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        ...data.entries.map((entry) {
          final percent = maxValue == 0 ? 0.0 : entry.value / maxValue;

          return Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: percent,
                          minHeight: 10,
                          backgroundColor: Colors.grey,
                          color: const Color(0xff08aff0),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${entry.value}",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }


  Widget buildSurveyDetailList() {
    if (surveys.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Chưa có khảo sát nào",
            style: TextStyle(fontSize: 15),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Nhấn vào khảo sát để xem thống kê chi tiết câu trả lời",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...surveys.map((survey) {
          return Card(
            color: Colors.white,
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xff08aff0),
                child: Icon(Icons.assignment, color: Colors.white),
              ),
              title: Text(
                survey.tenKhaoSat,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              ),
              subtitle: Text("Phản hồi: ${survey.soPhanHoi} | Hoàn thành: ${survey.soHoanThanh}"),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SurveyStatisticsDetail(khaoSat: survey),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget buildContent() {
    if (selectedMode == "Xem tỷ lệ phản hồi khảo sát") {
      return buildResponseRate();
    }

    if (selectedMode == "Xem chi tiết từng khảo sát") {
      return buildSurveyDetailList();
    }

    return buildOverview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text("Dashboard phân tích khảo sát"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                DropdownButtonFormField<String>(
                  value: selectedMode,
                  decoration: const InputDecoration(
                    labelText: "Lựa chọn phân tích",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  items: modes.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMode = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                buildContent(),
              ],
            ),
    );
  }
}
