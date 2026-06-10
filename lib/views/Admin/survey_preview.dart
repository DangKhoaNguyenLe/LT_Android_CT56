import 'package:flutter/material.dart';

import '../../models/khao_sat.dart';
import '../../models/cau_hoi.dart';

class SurveyPreviewPage extends StatelessWidget {
  final KhaoSat khaoSat;

  const SurveyPreviewPage({
    super.key,
    required this.khaoSat,
  });

  String formatDate(DateTime? date) {
    if (date == null) return "Chưa chọn";
    return "${date.day}/${date.month}/${date.year}";
  }

  Widget buildQuestionPreview(CauHoi cauHoi, int index) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Câu ${index + 1}: ${cauHoi.noiDung.isEmpty ? "Chưa nhập nội dung" : cauHoi.noiDung}",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),

            if (cauHoi.batBuoc)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  "* Bắt buộc",
                  style: TextStyle(color: Colors.red),
                ),
              ),

            if (cauHoi.hinhAnh != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Container(
                  width: double.infinity,
                  height: 90,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xffe8eef2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Ảnh minh họa câu hỏi",
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),

            const SizedBox(height: 8),

            if (cauHoi.loaiCauHoi == LoaiCauHoi.tracNghiem)
              ...List.generate(cauHoi.dapAns.length, (i) {
                return RadioListTile<int>(
                  value: i,
                  groupValue: null,
                  onChanged: null,
                  title: Text(
                    cauHoi.dapAns[i].noiDung.isEmpty
                        ? "Đáp án ${i + 1}"
                        : cauHoi.dapAns[i].noiDung,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              })
            else
              const TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: "Câu trả lời của bạn",
                  border: OutlineInputBorder(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = khaoSat.tenKhaoSat.trim().isEmpty
        ? "Khảo sát chưa đặt tên"
        : khaoSat.tenKhaoSat;

    final description =
        khaoSat.moTa.trim().isEmpty ? "Chưa có mô tả" : khaoSat.moTa;

    return Scaffold(
      backgroundColor: const Color(0xffd9d9d9),
      appBar: AppBar(
        title: const Text("Xem trước khảo sát"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    description,
                    style: const TextStyle(color: Colors.black87),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Danh mục: ${khaoSat.danhMuc?.tenDanhMuc ?? "Chưa chọn"}",
                    style: const TextStyle(color: Colors.black),
                  ),

                  Text(
                    "Trạng thái: ${khaoSat.getTrangThaiText()}",
                    style: const TextStyle(color: Colors.black),
                  ),

                  Text(
                    "Thời gian: ${formatDate(khaoSat.ngayBatDau)} - ${formatDate(khaoSat.ngayKetThuc)}",
                    style: const TextStyle(color: Colors.black),
                  ),

                  Text(
                    "Phần thưởng: ${khaoSat.getPhanThuongText()}",
                    style: const TextStyle(color: Colors.black),
                  ),

                  Text(
                    "Giới hạn: ${khaoSat.gioiHanNguoiThamGia ?? "Không giới hạn"} người",
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            "Danh sách câu hỏi",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 10),

          if (khaoSat.cauHois.isEmpty)
            const Card(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Center(
                  child: Text(
                    "Chưa có câu hỏi nào",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            )
          else
            ...List.generate(
              khaoSat.cauHois.length,
              (index) => buildQuestionPreview(
                khaoSat.cauHois[index],
                index,
              ),
            ),
        ],
      ),
    );
  }
}
