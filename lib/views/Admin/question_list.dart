import 'package:flutter/material.dart';

import '../../models/khao_sat.dart';

import 'add_question.dart';
import 'edit_question.dart';

class QuestionListPage extends StatefulWidget {
  final KhaoSat khaoSat;

  const QuestionListPage({
    super.key,
    required this.khaoSat,
  });

  @override
  State<QuestionListPage> createState() => _QuestionListPageState();
}

class _QuestionListPageState extends State<QuestionListPage> {
  void deleteQuestion(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xóa câu hỏi"),
        content: const Text("Bạn có chắc muốn xóa câu hỏi này không?"),
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
            onPressed: () {
              setState(() {
                widget.khaoSat.cauHois.removeAt(index);
              });

              Navigator.pop(context);
            },
            child: const Text("Xóa"),
          ),
        ],
      ),
    );
  }

  String getQuestionTypeText(index) {
    final cauHoi = widget.khaoSat.cauHois[index];

    if (cauHoi.loaiCauHoi.name == "tracNghiem") {
      return "Trắc nghiệm";
    }

    return "Tự luận";
  }

  Widget buildQuestionItem(int index) {
    final cauHoi = widget.khaoSat.cauHois[index];

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xff08aff0),
          child: Text(
            "${index + 1}",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          cauHoi.noiDung.isEmpty ? "Câu hỏi chưa có nội dung" : cauHoi.noiDung,
          style: const TextStyle(color: Colors.black),
        ),
        subtitle: Text(
          "Loại: ${getQuestionTypeText(index)}\n"
          "${cauHoi.batBuoc ? "Bắt buộc trả lời" : "Không bắt buộc"}\n"
          "Số đáp án: ${cauHoi.dapAns.length}",
          style: const TextStyle(color: Colors.black87),
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == "edit") {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditQuestionPage(cauHoi: cauHoi),
                ),
              );

              setState(() {});
            } else if (value == "delete") {
              deleteQuestion(index);
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: "edit",
              child: Text("Sửa câu hỏi"),
            ),
            PopupMenuDivider(),
            PopupMenuItem(
              value: "delete",
              child: Text(
                "Xóa",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd9d9d9),
      appBar: AppBar(
        title: Text(
          widget.khaoSat.tenKhaoSat,
          style: const TextStyle(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: widget.khaoSat.cauHois.isEmpty
          ? const Center(
              child: Text("Khảo sát chưa có câu hỏi nào"),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: widget.khaoSat.cauHois.length,
              itemBuilder: (context, index) {
                return buildQuestionItem(index);
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff08aff0),
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddQuestionPage(khaoSat: widget.khaoSat),
            ),
          );

          setState(() {});
        },
      ),
    );
  }
}
