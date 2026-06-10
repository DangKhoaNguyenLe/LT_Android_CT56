import 'package:flutter/material.dart';

import '../../models/khao_sat.dart';
import '../../models/cau_hoi.dart';
import '../../models/dap_an.dart';

class AddQuestionPage extends StatefulWidget {
  final KhaoSat khaoSat;

  const AddQuestionPage({
    super.key,
    required this.khaoSat,
  });

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final TextEditingController noiDungController = TextEditingController();

  LoaiCauHoi loaiCauHoi = LoaiCauHoi.tuLuan;
  bool batBuoc = false;
  String? hinhAnh;

  List<TextEditingController> dapAnControllers = [];

  void addAnswer() {
    setState(() {
      dapAnControllers.add(TextEditingController());
    });
  }

  void removeAnswer(int index) {
    setState(() {
      dapAnControllers.removeAt(index);
    });
  }

  void chooseQuestionImage() {
    setState(() {
      hinhAnh = "Đã chọn ảnh cho câu hỏi";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Đã chọn ảnh minh họa cho câu hỏi"),
      ),
    );
  }

  void saveQuestion() {
    if (noiDungController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng nhập nội dung câu hỏi"),
        ),
      );
      return;
    }

    if (loaiCauHoi == LoaiCauHoi.tracNghiem &&
        dapAnControllers.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Câu hỏi trắc nghiệm cần ít nhất 2 đáp án"),
        ),
      );
      return;
    }

    final dapAns = loaiCauHoi == LoaiCauHoi.tracNghiem
        ? List.generate(
            dapAnControllers.length,
            (index) => DapAn(
              id: index + 1,
              noiDung: dapAnControllers[index].text.trim(),
            ),
          )
        : <DapAn>[];

    final cauHoi = CauHoi(
      id: widget.khaoSat.cauHois.length + 1,
      noiDung: noiDungController.text.trim(),
      loaiCauHoi: loaiCauHoi,
      batBuoc: batBuoc,
      hinhAnh: hinhAnh,
      dapAns: dapAns,
    );

    widget.khaoSat.cauHois.add(cauHoi);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Đã thêm câu hỏi"),
      ),
    );

    Navigator.pop(context, true);
  }

  Widget buildAnswerInput(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: dapAnControllers[index],
              decoration: InputDecoration(
                labelText: "Đáp án ${index + 1}",
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.image, color: Color(0xff08aff0)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Đã chọn ảnh cho đáp án ${index + 1}"),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => removeAnswer(index),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMultipleChoice = loaiCauHoi == LoaiCauHoi.tracNghiem;

    return Scaffold(
      backgroundColor: const Color(0xffd9d9d9),
      appBar: AppBar(
        title: const Text("Thêm câu hỏi"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          TextField(
            controller: noiDungController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: "Nội dung câu hỏi",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<LoaiCauHoi>(
            value: loaiCauHoi,
            decoration: const InputDecoration(
              labelText: "Loại câu hỏi",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: LoaiCauHoi.tuLuan,
                child: Text("Tự luận"),
              ),
              DropdownMenuItem(
                value: LoaiCauHoi.tracNghiem,
                child: Text("Trắc nghiệm"),
              ),
            ],
            onChanged: (value) {
              setState(() {
                loaiCauHoi = value!;

                if (loaiCauHoi == LoaiCauHoi.tracNghiem &&
                    dapAnControllers.isEmpty) {
                  dapAnControllers.add(TextEditingController());
                  dapAnControllers.add(TextEditingController());
                }

                if (loaiCauHoi == LoaiCauHoi.tuLuan) {
                  dapAnControllers.clear();
                }
              });
            },
          ),

          const SizedBox(height: 4),

          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("Không thể bỏ qua / Bắt buộc"),
            value: batBuoc,
            onChanged: (value) {
              setState(() {
                batBuoc = value ?? false;
              });
            },
          ),

          OutlinedButton.icon(
            onPressed: chooseQuestionImage,
            icon: const Icon(Icons.image),
            label: const Text("Tải ảnh cho câu hỏi"),
          ),

          if (hinhAnh != null)
            Text(
              hinhAnh!,
              style: const TextStyle(
                color: Colors.green,
                fontSize: 12,
              ),
            ),

          if (isMultipleChoice) ...[
            const SizedBox(height: 16),

            const Text(
              "Danh sách đáp án",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            ...List.generate(
              dapAnControllers.length,
              buildAnswerInput,
            ),

            TextButton.icon(
              onPressed: addAnswer,
              icon: const Icon(Icons.add),
              label: const Text("Thêm đáp án"),
            ),
          ],

          const SizedBox(height: 20),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff08aff0),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: saveQuestion,
            child: const Text("Lưu câu hỏi"),
          ),
        ],
      ),
    );
  }
}
