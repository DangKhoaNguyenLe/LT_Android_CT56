import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/cau_hoi.dart';
import '../../models/dap_an.dart';

import 'survey_setup_page.dart';

class CreateSurveyPage extends StatefulWidget {
  const CreateSurveyPage({super.key});

  @override
  State<CreateSurveyPage> createState() => _CreateSurveyPageState();
}

class _CreateSurveyPageState extends State<CreateSurveyPage> {
  final TextEditingController tenController = TextEditingController();
  final TextEditingController moTaController = TextEditingController();

  List<CauHoi> cauHois = [
    CauHoi(
      id: 1,
      noiDung: "",
      loaiCauHoi: LoaiCauHoi.tracNghiem,
      batBuoc: false,
      dapAns: [
        DapAn(id: 1, noiDung: ""),
        DapAn(id: 2, noiDung: ""),
      ],
    ),
  ];

  void addQuestion() {
    setState(() {
      cauHois.add(
        CauHoi(
          id: cauHois.length + 1,
          noiDung: "",
          loaiCauHoi: LoaiCauHoi.tracNghiem,
          batBuoc: false,
          dapAns: [
            DapAn(id: 1, noiDung: ""),
            DapAn(id: 2, noiDung: ""),
          ],
        ),
      );
    });
  }

  Future<void> changeQuestionType(int index, String type) async {
    final cauHoi = cauHois[index];

    if (type == "trac_nghiem") {
      setState(() {
        cauHoi.loaiCauHoi = LoaiCauHoi.tracNghiem;
        cauHoi.hinhAnh = null;

        if (cauHoi.dapAns.length < 2) {
          cauHoi.dapAns = [
            DapAn(id: 1, noiDung: ""),
            DapAn(id: 2, noiDung: ""),
          ];
        }
      });
    }

    if (type == "text") {
      setState(() {
        cauHoi.loaiCauHoi = LoaiCauHoi.tuLuan;
        cauHoi.hinhAnh = null;
        cauHoi.dapAns.clear();
      });
    }

    if (type == "anh" || type == "trac_nghiem_anh") {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      
      if (pickedFile != null) {
        setState(() {
          cauHoi.loaiCauHoi = type == "anh" ? LoaiCauHoi.tuLuan : LoaiCauHoi.tracNghiem;
          cauHoi.hinhAnh = pickedFile.path;
          
          if (type == "anh") {
            cauHoi.dapAns.clear();
          } else {
            if (cauHoi.dapAns.length < 2) {
              cauHoi.dapAns = [
                DapAn(id: 1, noiDung: ""),
                DapAn(id: 2, noiDung: ""),
              ];
            }
          }
        });
      }
    }
  }

  void addOption(int questionIndex) {
    setState(() {
      final dapAns = cauHois[questionIndex].dapAns;

      dapAns.add(
        DapAn(
          id: dapAns.length + 1,
          noiDung: "",
        ),
      );
    });
  }

  void removeOption(int questionIndex, int optionIndex) {
    final cauHoi = cauHois[questionIndex];

    if (cauHoi.loaiCauHoi == LoaiCauHoi.tracNghiem &&
        cauHoi.dapAns.length <= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Câu hỏi trắc nghiệm phải có ít nhất 2 đáp án"),
        ),
      );
      return;
    }

    setState(() {
      cauHoi.dapAns.removeAt(optionIndex);
    });
  }

  void removeQuestion(int index) {
    setState(() {
      cauHois.removeAt(index);
    });
  }

  bool validateCreateSurvey() {
    if (tenController.text.trim().isEmpty) {
      tenController.text = "Mẫu khảo sát";
    }

    if (cauHois.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng thêm ít nhất 1 câu hỏi"),
        ),
      );
      return false;
    }

    for (int i = 0; i < cauHois.length; i++) {
      final cauHoi = cauHois[i];

      if (cauHoi.noiDung.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Vui lòng nhập nội dung câu hỏi ${i + 1}"),
          ),
        );
        return false;
      }

      if (cauHoi.loaiCauHoi == LoaiCauHoi.tracNghiem) {
        if (cauHoi.dapAns.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Câu hỏi ${i + 1} là trắc nghiệm nên phải có đáp án",
              ),
            ),
          );
          return false;
        }

        final dapAnHopLe = cauHoi.dapAns.where((dapAn) {
          return dapAn.noiDung.trim().isNotEmpty;
        }).toList();

        if (dapAnHopLe.length < 2) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Câu hỏi trắc nghiệm ${i + 1} phải có ít nhất 2 đáp án",
              ),
            ),
          );
          return false;
        }
      }
    }

    return true;
  }

  void goNext() async {
    if (!validateCreateSurvey()) {
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SurveySetupPage(
          tenKhaoSat: tenController.text.trim(),
          moTa: moTaController.text.trim(),
          cauHois: cauHois,
        ),
      ),
    );

    if (result == true) {
      Navigator.pop(context, true);
    }
  }

  String getQuestionTypeLabel(CauHoi cauHoi) {
    if (cauHoi.loaiCauHoi == LoaiCauHoi.tuLuan && cauHoi.hinhAnh != null) {
      return "Câu hỏi bằng ảnh";
    }

    if (cauHoi.loaiCauHoi == LoaiCauHoi.tuLuan) {
      return "Văn bản";
    }

    if (cauHoi.loaiCauHoi == LoaiCauHoi.tracNghiem &&
        cauHoi.hinhAnh != null) {
      return "Trắc nghiệm có ảnh";
    }

    return "Trắc nghiệm";
  }

  Widget buildTitleCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            TextField(
              controller: tenController,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              decoration: const InputDecoration(
                hintText: "Mẫu khảo sát",
                border: InputBorder.none,
              ),
            ),
            TextField(
              controller: moTaController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: "Mô tả biểu mẫu",
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuestionCard(int index) {
    final cauHoi = cauHois[index];

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 8, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: cauHoi.noiDung,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      hintText: "Câu hỏi không có tiêu đề",
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      cauHoi.noiDung = value;
                    },
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  onSelected: (value) async {
                    await changeQuestionType(index, value);
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: "trac_nghiem",
                      child: Row(
                        children: [
                          Icon(Icons.radio_button_checked),
                          SizedBox(width: 8),
                          Text("Trắc nghiệm"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "text",
                      child: Row(
                        children: [
                          Icon(Icons.short_text),
                          SizedBox(width: 8),
                          Text("Văn bản"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "anh",
                      child: Row(
                        children: [
                          Icon(Icons.image),
                          SizedBox(width: 8),
                          Text("Câu hỏi bằng ảnh"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "trac_nghiem_anh",
                      child: Row(
                        children: [
                          Icon(Icons.image_search),
                          SizedBox(width: 8),
                          Text("Trắc nghiệm có ảnh"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xffeeeeee),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                getQuestionTypeLabel(cauHoi),
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
            ),

            if (cauHoi.hinhAnh != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xffe8eef2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(cauHoi.hinhAnh!),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Text('Không thể hiển thị ảnh', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 8),

            if (cauHoi.loaiCauHoi == LoaiCauHoi.tracNghiem)
              ...List.generate(cauHoi.dapAns.length, (i) {
                return Row(
                  children: [
                    const Icon(
                      Icons.radio_button_unchecked,
                      size: 18,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        initialValue: cauHoi.dapAns[i].noiDung,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Tùy chọn ${i + 1}",
                          border: const UnderlineInputBorder(),
                        ),
                        onChanged: (value) {
                          cauHoi.dapAns[i].noiDung = value;
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => removeOption(index, i),
                    ),
                  ],
                );
              })
            else
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: "Câu trả lời dạng văn bản",
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),

            if (cauHoi.loaiCauHoi == LoaiCauHoi.tracNghiem)
              TextButton.icon(
                onPressed: () => addOption(index),
                icon: const Icon(Icons.add),
                label: const Text("Thêm tùy chọn"),
              ),

            const Divider(),

            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      "Bắt buộc",
                      style: TextStyle(color: Colors.black),
                    ),
                    value: cauHoi.batBuoc,
                    onChanged: (value) {
                      setState(() {
                        cauHoi.batBuoc = value ?? false;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.black),
                  onPressed: () => removeQuestion(index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text("Tạo khảo sát"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          buildTitleCard(),
          const SizedBox(height: 12),
          ...List.generate(cauHois.length, buildQuestionCard),
          Center(
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: addQuestion,
              child: const Icon(Icons.add, color: Colors.black),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: goNext,
                  child: const Text("Tiếp theo"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
