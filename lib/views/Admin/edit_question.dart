import 'package:flutter/material.dart';

import '../../models/cau_hoi.dart';
import '../../models/dap_an.dart';

class EditQuestionPage extends StatefulWidget {
  final CauHoi cauHoi;

  const EditQuestionPage({
    super.key,
    required this.cauHoi,
  });

  @override
  State<EditQuestionPage> createState() => _EditQuestionPageState();
}

class _EditQuestionPageState extends State<EditQuestionPage> {
  late TextEditingController noiDungController;
  late LoaiCauHoi loaiCauHoi;
  late bool batBuoc;
  String? hinhAnh;

  List<TextEditingController> dapAnControllers = [];

  @override
  void initState() {
    super.initState();

    noiDungController = TextEditingController(text: widget.cauHoi.noiDung);
    loaiCauHoi = widget.cauHoi.loaiCauHoi;
    batBuoc = widget.cauHoi.batBuoc;
    hinhAnh = widget.cauHoi.hinhAnh;

    dapAnControllers = widget.cauHoi.dapAns
        .map((dapAn) => TextEditingController(text: dapAn.noiDung))
        .toList();
  }

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
  }

  void saveEdit() {
    if (noiDungController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nội dung câu hỏi không được để trống"),
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

    widget.cauHoi.noiDung = noiDungController.text.trim();
    widget.cauHoi.loaiCauHoi = loaiCauHoi;
    widget.cauHoi.batBuoc = batBuoc;
    widget.cauHoi.hinhAnh = hinhAnh;

    widget.cauHoi.dapAns = loaiCauHoi == LoaiCauHoi.tracNghiem
        ? List.generate(
            dapAnControllers.length,
            (index) => DapAn(
              id: index + 1,
              noiDung: dapAnControllers[index].text.trim(),
            ),
          )
        : [];

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Đã cập nhật câu hỏi"),
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
        title: const Text("Sửa câu hỏi"),
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
              style: const TextStyle(color: Colors.green, fontSize: 12),
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
            onPressed: saveEdit,
            child: const Text("Lưu thay đổi"),
          ),
        ],
      ),
    );
  }
}
