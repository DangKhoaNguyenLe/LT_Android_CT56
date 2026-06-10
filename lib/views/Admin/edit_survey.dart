import 'package:flutter/material.dart';

import '../../controllers/khao_sat_controller.dart';
import '../../models/khao_sat.dart';
import '../../models/danh_muc.dart';

class EditSurveyPage extends StatefulWidget {
  final KhaoSat khaoSat;

  const EditSurveyPage({
    super.key,
    required this.khaoSat,
  });

  @override
  State<EditSurveyPage> createState() => _EditSurveyPageState();
}

class _EditSurveyPageState extends State<EditSurveyPage> {
  final KhaoSatController controller = KhaoSatController();

  late TextEditingController tenController;
  late TextEditingController moTaController;
  late TextEditingController phanThuongController;
  late TextEditingController gioiHanController;

  DanhMuc? selectedDanhMuc;
  LoaiPhanThuong selectedReward = LoaiPhanThuong.khongCo;
  TrangThaiKhaoSat selectedStatus = TrangThaiKhaoSat.banNhap;

  DateTime? ngayBatDau;
  DateTime? ngayKetThuc;

  List<DanhMuc> danhMucs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    tenController = TextEditingController(text: widget.khaoSat.tenKhaoSat);
    moTaController = TextEditingController(text: widget.khaoSat.moTa);
    phanThuongController =
        TextEditingController(text: widget.khaoSat.giaTriPhanThuong ?? "");
    gioiHanController = TextEditingController(
      text: widget.khaoSat.gioiHanNguoiThamGia?.toString() ?? "",
    );

    selectedDanhMuc = widget.khaoSat.danhMuc;
    selectedReward = widget.khaoSat.loaiPhanThuong;
    selectedStatus = widget.khaoSat.trangThai;
    ngayBatDau = widget.khaoSat.ngayBatDau;
    ngayKetThuc = widget.khaoSat.ngayKetThuc;

    _loadData();
  }

  Future<void> _loadData() async {
    final list = await controller.getDanhMucList();
    setState(() {
      danhMucs = list;
      isLoading = false;
    });
  }

  Future<void> pickStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: ngayBatDau ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      setState(() {
        ngayBatDau = date;
      });
    }
  }

  Future<void> pickEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: ngayKetThuc ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (date != null) {
      setState(() {
        ngayKetThuc = date;
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return "Chưa chọn";
    return "${date.day}/${date.month}/${date.year}";
  }

  Future<void> updateSurvey() async {
    widget.khaoSat.tenKhaoSat = tenController.text.trim();
    widget.khaoSat.moTa = moTaController.text.trim();
    widget.khaoSat.danhMuc = selectedDanhMuc;
    widget.khaoSat.trangThai = selectedStatus;
    widget.khaoSat.ngayBatDau = ngayBatDau;
    widget.khaoSat.ngayKetThuc = ngayKetThuc;
    widget.khaoSat.loaiPhanThuong = selectedReward;
    widget.khaoSat.giaTriPhanThuong =
        phanThuongController.text.trim().isEmpty
            ? null
            : phanThuongController.text.trim();
    widget.khaoSat.gioiHanNguoiThamGia =
        gioiHanController.text.trim().isEmpty
            ? null
            : int.tryParse(gioiHanController.text.trim());

    final error = controller.validateSurvey(
      widget.khaoSat,
      isPublish: selectedStatus == TrangThaiKhaoSat.dangMo,
    );

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    await controller.updateSurvey(widget.khaoSat);

    if(context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cập nhật khảo sát thành công")),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sửa khảo sát"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          TextField(
            controller: tenController,
            decoration: const InputDecoration(
              labelText: "Tên khảo sát",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: moTaController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: "Mô tả khảo sát",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<DanhMuc>(
            value: selectedDanhMuc,
            decoration: const InputDecoration(
              labelText: "Danh mục khảo sát",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
            items: danhMucs.map((dm) {
              return DropdownMenuItem(
                value: dm,
                child: Text(dm.tenDanhMuc),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedDanhMuc = value;
              });
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<TrangThaiKhaoSat>(
            value: selectedStatus,
            decoration: const InputDecoration(
              labelText: "Trạng thái khảo sát",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: TrangThaiKhaoSat.banNhap,
                child: Text("Bản nháp"),
              ),
              DropdownMenuItem(
                value: TrangThaiKhaoSat.dangMo,
                child: Text("Đang mở"),
              ),
              DropdownMenuItem(
                value: TrangThaiKhaoSat.daDong,
                child: Text("Đã đóng"),
              ),
            ],
            onChanged: (value) {
              setState(() {
                selectedStatus = value!;
              });
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: pickStartDate,
                  icon: const Icon(Icons.date_range),
                  label: Text("Bắt đầu: ${formatDate(ngayBatDau)}"),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: pickEndDate,
                  icon: const Icon(Icons.event),
                  label: Text("Kết thúc: ${formatDate(ngayKetThuc)}"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<LoaiPhanThuong>(
            value: selectedReward,
            decoration: const InputDecoration(
              labelText: "Loại phần thưởng",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: LoaiPhanThuong.khongCo,
                child: Text("Không có"),
              ),
              DropdownMenuItem(
                value: LoaiPhanThuong.voucher,
                child: Text("Voucher"),
              ),
              DropdownMenuItem(
                value: LoaiPhanThuong.tienMat,
                child: Text("Tiền mặt"),
              ),
              DropdownMenuItem(
                value: LoaiPhanThuong.diemTichLuy,
                child: Text("Điểm tích lũy"),
              ),
            ],
            onChanged: (value) {
              setState(() {
                selectedReward = value!;
              });
            },
          ),
          if (selectedReward != LoaiPhanThuong.khongCo) ...[
            const SizedBox(height: 12),
            TextField(
              controller: phanThuongController,
              decoration: const InputDecoration(
                labelText: "Giá trị phần thưởng",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            controller: gioiHanController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Giới hạn người tham gia",
              hintText: "Bỏ trống nếu không giới hạn",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 22),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff08aff0),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: updateSurvey,
            child: const Text("Lưu thay đổi"),
          ),
        ],
      ),
    );
  }
}
