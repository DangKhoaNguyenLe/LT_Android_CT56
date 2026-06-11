import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  List<String?> dapAnImages = [];

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
    dapAnImages = widget.cauHoi.dapAns
        .map((dapAn) => dapAn.hinhAnh)
        .toList();
  }

  void addAnswer() {
    setState(() {
      dapAnControllers.add(TextEditingController());
      dapAnImages.add(null);
    });
  }

  void removeAnswer(int index) {
    setState(() {
      dapAnControllers.removeAt(index);
      dapAnImages.removeAt(index);
    });
  }

  Future<void> chooseQuestionImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        hinhAnh = pickedFile.path;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đã chọn ảnh minh họa cho câu hỏi")),
        );
      }
    }
  }

  Future<void> chooseAnswerImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        dapAnImages[index] = pickedFile.path;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đã chọn ảnh cho đáp án ${index + 1}")),
        );
      }
    }
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
              id: widget.cauHoi.dapAns.length > index ? widget.cauHoi.dapAns[index].id : index + 1,
              noiDung: dapAnControllers[index].text.trim(),
              hinhAnh: dapAnImages[index],
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
            icon: Icon(Icons.image, color: dapAnImages[index] != null ? Colors.green : const Color(0xff08aff0)),
            onPressed: () => chooseAnswerImage(index),
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
                  dapAnImages.addAll([null, null]);
                }

                if (loaiCauHoi == LoaiCauHoi.tuLuan) {
                  dapAnControllers.clear();
                  dapAnImages.clear();
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

          if (hinhAnh != null) ...[
            const SizedBox(height: 8),
            Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(hinhAnh!),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Text('Không thể hiển thị ảnh', style: TextStyle(color: Colors.red)),
                  ),
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  hinhAnh = null;
                });
              },
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text("Xóa ảnh", style: TextStyle(color: Colors.red)),
            )
          ],

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
