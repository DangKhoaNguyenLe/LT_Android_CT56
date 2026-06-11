import 'package:flutter/material.dart';
import '../../controllers/danh_muc_phan_thuong_controller.dart';
import '../../models/danh_muc_phan_thuong.dart';
import '../../models/khao_sat.dart';

class ManageRewardScreen extends StatefulWidget {
  const ManageRewardScreen({super.key});

  @override
  State<ManageRewardScreen> createState() => _ManageRewardScreenState();
}

class _ManageRewardScreenState extends State<ManageRewardScreen> {
  final DanhMucPhanThuongController _controller = DanhMucPhanThuongController();
  
  List<DanhMucPhanThuong> _rewards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final rewards = await _controller.getAll();
      setState(() {
        _rewards = rewards;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải dữ liệu: $e')),
        );
      }
    }
  }

  IconData _getRewardIcon(LoaiPhanThuong type) {
    switch (type) {
      case LoaiPhanThuong.tienMat:
        return Icons.attach_money;
      case LoaiPhanThuong.voucher:
        return Icons.card_giftcard;
      case LoaiPhanThuong.diemTichLuy:
        return Icons.star;
      default:
        return Icons.wallet_giftcard;
    }
  }

  Color _getRewardColor(LoaiPhanThuong type) {
    switch (type) {
      case LoaiPhanThuong.tienMat:
        return Colors.green;
      case LoaiPhanThuong.voucher:
        return Colors.orange;
      case LoaiPhanThuong.diemTichLuy:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getRewardTypeText(LoaiPhanThuong type) {
    switch (type) {
      case LoaiPhanThuong.tienMat:
        return "Tiền mặt";
      case LoaiPhanThuong.voucher:
        return "Voucher";
      case LoaiPhanThuong.diemTichLuy:
        return "Điểm tích lũy";
      default:
        return "Khác";
    }
  }

  void _showRewardDialog({DanhMucPhanThuong? reward}) {
    final _formKey = GlobalKey<FormState>();
    String tenPhanThuong = reward?.tenPhanThuong ?? '';
    LoaiPhanThuong selectedLoai = reward?.loaiPhanThuong ?? LoaiPhanThuong.voucher;
    String giaTri = reward?.giaTri ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(reward == null ? 'Thêm mẫu phần thưởng' : 'Sửa mẫu phần thưởng'),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        initialValue: tenPhanThuong,
                        decoration: const InputDecoration(labelText: 'Tên hiển thị (Ví dụ: Thẻ cào 50k)'),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Vui lòng nhập tên hiển thị' : null,
                        onSaved: (val) => tenPhanThuong = val!,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<LoaiPhanThuong>(
                        decoration: const InputDecoration(labelText: 'Loại phần thưởng'),
                        value: selectedLoai,
                        items: const [
                          DropdownMenuItem(value: LoaiPhanThuong.voucher, child: Text('Voucher')),
                          DropdownMenuItem(value: LoaiPhanThuong.tienMat, child: Text('Tiền mặt')),
                          DropdownMenuItem(value: LoaiPhanThuong.diemTichLuy, child: Text('Điểm tích lũy')),
                        ],
                        onChanged: (val) {
                          setDialogState(() {
                            selectedLoai = val!;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        initialValue: giaTri,
                        decoration: const InputDecoration(labelText: 'Giá trị (Ví dụ: 50.000 VNĐ)'),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Vui lòng nhập giá trị' : null,
                        onSaved: (val) => giaTri = val!,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      
                      if (reward == null) {
                        DanhMucPhanThuong newReward = DanhMucPhanThuong(
                          tenPhanThuong: tenPhanThuong,
                          loaiPhanThuong: selectedLoai,
                          giaTri: giaTri,
                        );
                        await _controller.addPhanThuong(newReward);
                      } else {
                        DanhMucPhanThuong updatedReward = DanhMucPhanThuong(
                          idPhanThuong: reward.idPhanThuong,
                          tenPhanThuong: tenPhanThuong,
                          loaiPhanThuong: selectedLoai,
                          giaTri: giaTri,
                        );
                        await _controller.updatePhanThuong(updatedReward);
                      }

                      Navigator.pop(context);
                      _loadData();
                    }
                  },
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteReward(DanhMucPhanThuong reward) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa mẫu phần thưởng này không? (Sẽ không ảnh hưởng các khảo sát cũ)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              if (reward.idPhanThuong != null) {
                await _controller.deletePhanThuong(reward.idPhanThuong!);
              }
              Navigator.pop(context);
              _loadData();
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Quản lý mẫu phần thưởng'),
        backgroundColor: const Color(0xFF0EA5E9),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rewards.isEmpty
              ? const Center(
                  child: Text(
                    'Chưa có mẫu phần thưởng nào.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _rewards.length,
                  itemBuilder: (context, index) {
                    final reward = _rewards[index];

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _getRewardColor(reward.loaiPhanThuong).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _getRewardIcon(reward.loaiPhanThuong),
                                color: _getRewardColor(reward.loaiPhanThuong),
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reward.tenPhanThuong,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(
                                        "${_getRewardTypeText(reward.loaiPhanThuong)}:",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        reward.giaTri,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: _getRewardColor(reward.loaiPhanThuong),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _showRewardDialog(reward: reward),
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.all(4),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteReward(reward),
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.all(4),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRewardDialog(),
        backgroundColor: const Color(0xFF0EA5E9),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
