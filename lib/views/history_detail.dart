import 'package:flutter/material.dart';
import '../models/khao_sat.dart';
import '../models/lich_su_khao_sat.dart';
import '../models/chi_tiet_lich_su.dart';
import '../models/cau_hoi.dart';

class HistoryDetailScreen extends StatelessWidget {
  final KhaoSat khaoSat;
  final LichSuKhaoSat lichSu;

  const HistoryDetailScreen({
    super.key,
    required this.khaoSat,
    required this.lichSu,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd9d9d9),
      appBar: AppBar(
        title: const Text('Chi tiết bài làm'),
        backgroundColor: const Color(0xFF0EA5E9),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.white,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    khaoSat.tenKhaoSat,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Ngày nộp: ${lichSu.ngayLam.day}/${lichSu.ngayLam.month}/${lichSu.ngayLam.year} ${lichSu.ngayLam.hour}:${lichSu.ngayLam.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...khaoSat.cauHois.asMap().entries.map((entry) {
            final index = entry.key;
            final cauHoi = entry.value;

            // Lọc ra các câu trả lời của user cho câu hỏi này
            final listTraLoi = lichSu.chiTietList
                .where((c) => c.idCauHoi == cauHoi.id)
                .toList();
                
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Câu ${index + 1}: ${cauHoi.noiDung}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (cauHoi.loaiCauHoi == LoaiCauHoi.tuLuan)
                      TextField(
                        controller: TextEditingController(
                          text: listTraLoi.isNotEmpty ? listTraLoi.first.noiDungTraLoi : "",
                        ),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        enabled: false,
                      )
                    else
                      ...cauHoi.dapAns.map((dapAn) {
                        bool isSelected = listTraLoi.any((c) => c.idDapAn == dapAn.id);

                        return RadioListTile<int>(
                          title: Text(
                            dapAn.noiDung,
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.black54,
                              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                            ),
                          ),
                          value: dapAn.id,
                          groupValue: isSelected ? dapAn.id : -1,
                          onChanged: null, // Read-only
                          activeColor: const Color(0xFF0EA5E9),
                        );
                      }),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
