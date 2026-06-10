import 'package:flutter/material.dart';

import '../../controllers/thong_ke_controller.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final ThongKeController controller = ThongKeController();

  String selectedMode = "Tổng quan phân tích";

  final List<String> modes = [
    "Tổng quan phân tích",
    "Xem tỷ lệ phản hồi khảo sát",
    "Xem đánh giá ẩn danh",
  ];

  Widget buildSummaryCard({
    required String title,
    required IconData icon,
    required String value,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(14),
        height: 140,
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
            const SizedBox(height: 12),
            Icon(
              icon,
              color: Colors.grey,
              size: 34,
            ),
            const SizedBox(height: 12),
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

  Widget buildOverview() {
    final tongPhanHoi = controller.getTongSoPhanHoi();
    final tongHoanThanh = controller.getTongSoHoanThanh();
    final tiLeHoanThanh = controller.getTiLeHoanThanh();
    final danhGiaTrungBinh = controller.getDanhGiaTrungBinh();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.7,
      children: [
        buildSummaryCard(
          title: "Tổng số phản hồi",
          icon: Icons.groups,
          value: tongPhanHoi.toString(),
        ),
        buildSummaryCard(
          title: "Khảo sát hoàn thành",
          icon: Icons.assignment_turned_in,
          value: tongHoanThanh.toString(),
        ),
        buildSummaryCard(
          title: "Tỉ lệ hoàn thành",
          icon: Icons.trending_up,
          value: "${tiLeHoanThanh.toStringAsFixed(1)}%",
        ),
        buildSummaryCard(
          title: "Đánh giá trung bình",
          icon: Icons.star_border,
          value: "${danhGiaTrungBinh.toStringAsFixed(1)}/5.0",
        ),
      ],
    );
  }

  Widget buildResponseRate() {
    final data = controller.getPhanHoiTheoKhaoSat();

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

  Widget buildAnonymousReview() {
    final surveys = controller.getAllSurveys()
        .where((item) => item.danhGiaTrungBinh > 0)
        .toList();

    if (surveys.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Chưa có đánh giá",
            style: TextStyle(fontSize: 15),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Đánh giá trung bình theo khảo sát",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        ...surveys.map((survey) {
          return Card(
            color: Colors.white,
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xff08aff0),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              title: Text(
                survey.tenKhaoSat,
                style: const TextStyle(color: Colors.black),
              ),
              subtitle: const Text(
                "Người dùng ẩn danh",
                style: TextStyle(color: Colors.black54),
              ),
              trailing: Text(
                "${survey.danhGiaTrungBinh.toStringAsFixed(1)}/5.0",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
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

    if (selectedMode == "Xem đánh giá ẩn danh") {
      return buildAnonymousReview();
    }

    return buildOverview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd9d9d9),
      appBar: AppBar(
        title: const Text("Dashboard phân tích khảo sát"),
        centerTitle: true,
      ),
      body: ListView(
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
