import 'package:flutter/material.dart';

import '../../controllers/khao_sat_controller.dart';
import '../../models/khao_sat.dart';

import 'tao_khao_sat.dart';
import 'xem_truoc_khao_sat.dart';

class ManageSurveyPage extends StatefulWidget {
  const ManageSurveyPage({super.key});

  @override
  State<ManageSurveyPage> createState() => _ManageSurveyPageState();
}

class _ManageSurveyPageState extends State<ManageSurveyPage> {
  final KhaoSatController controller = KhaoSatController();
  late List<KhaoSat> surveys;

  @override
  void initState() {
    super.initState();
    surveys = [];
    refreshData();
  }

  Future<void> refreshData() async {
    final fetched = await controller.getAll();
    fetched.sort((a, b) => b.ngayTao.compareTo(a.ngayTao));
    setState(() {
      surveys = fetched;
    });
  }

  void confirmDelete(KhaoSat survey) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xóa khảo sát"),
        content: Text(
          "Bạn có chắc muốn xóa '${survey.tenKhaoSat}' không?\n"
          "Toàn bộ câu hỏi bên trong cũng sẽ bị xóa.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await controller.deleteSurvey(survey.id);
              if(context.mounted) Navigator.pop(context);
              await refreshData();
            },
            child: const Text("Xóa"),
          ),
        ],
      ),
    );
  }

  Future<void> copySurvey(KhaoSat survey) async {
    await controller.copySurvey(survey);
    await refreshData();

    if(context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Đã sao chép khảo sát thành bản nháp"),
        ),
      );
    }
  }

  Future<void> updateSurveyStatus(KhaoSat survey, TrangThaiKhaoSat newStatus) async {
    survey.trangThai = newStatus;
    await controller.updateSurveyInfoOnly(survey);
    await refreshData();

    if(context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Đã cập nhật trạng thái thành: ${survey.getTrangThaiText()}"),
        ),
      );
    }
  }

  Color getStatusColor(KhaoSat survey) {
    if (survey.trangThai == TrangThaiKhaoSat.dangMo &&
        survey.gioiHanNguoiThamGia != null &&
        survey.gioiHanNguoiThamGia! > 0 &&
        survey.soNguoiThamGia >= survey.gioiHanNguoiThamGia!) {
      return Colors.grey;
    }

    if (survey.trangThai == TrangThaiKhaoSat.dangMo && survey.isClosedByTime()) {
      return Colors.grey;
    }

    switch (survey.trangThai) {
      case TrangThaiKhaoSat.banNhap:
        return Colors.orange;
      case TrangThaiKhaoSat.dangMo:
        return const Color(0xff08aff0);
      case TrangThaiKhaoSat.daDong:
        return Colors.grey;
    }
  }

  Widget buildSurveyItem(KhaoSat survey) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: getStatusColor(survey),
          child: const Icon(Icons.assignment, color: Colors.white),
        ),
        title: Text(
          survey.tenKhaoSat,
          style: const TextStyle(color: Colors.black),
        ),
        subtitle: Text(
          "Trạng thái: ${survey.getTrangThaiText()}\n"
          "Danh mục: ${survey.danhMuc?.tenDanhMuc ?? "Chưa chọn"}\n"
          "Câu hỏi: ${survey.cauHois.length}\n"
          "Người tham gia: ${survey.soNguoiThamGia}/${survey.gioiHanNguoiThamGia ?? "Không giới hạn"}\n"
          "Phần thưởng: ${survey.getPhanThuongText()}",
          style: const TextStyle(color: Colors.black87),
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == "preview") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SurveyPreviewPage(khaoSat: survey),
                ),
              );
            } else if (value == "edit") {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateSurveyPage(existingSurvey: survey),
                ),
              );
              refreshData();
            } else if (value == "copy") {
              copySurvey(survey);
            } else if (value == "publish") {
              updateSurveyStatus(survey, TrangThaiKhaoSat.dangMo);
            } else if (value == "close") {
              updateSurveyStatus(survey, TrangThaiKhaoSat.daDong);
            } else if (value == "delete") {
              confirmDelete(survey);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: "preview",
              child: Text("Xem trước"),
            ),
            const PopupMenuItem(
              value: "edit",
              child: Text("Chỉnh sửa"),
            ),
            const PopupMenuItem(
              value: "copy",
              child: Text("Sao chép"),
            ),
            const PopupMenuDivider(),
            if (survey.trangThai != TrangThaiKhaoSat.dangMo)
              const PopupMenuItem(
                value: "publish",
                child: Text("Xuất bản", style: TextStyle(color: Colors.green)),
              ),
            if (survey.trangThai == TrangThaiKhaoSat.dangMo)
              const PopupMenuItem(
                value: "close",
                child: Text("Đóng khảo sát", style: TextStyle(color: Colors.orange)),
              ),
            const PopupMenuItem(
              value: "delete",
              child: Text(
                "Xóa",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SurveyPreviewPage(khaoSat: survey),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text("Quản lý khảo sát"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateSurveyPage(),
                ),
              );

              refreshData();
            },
          ),
        ],
      ),
      body: surveys.isEmpty
          ? const Center(child: Text("Chưa có khảo sát nào"))
          : ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: surveys.length,
              itemBuilder: (context, index) {
                return buildSurveyItem(surveys[index]);
              },
            ),
    );
  }
}
