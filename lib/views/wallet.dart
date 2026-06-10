import 'package:flutter/material.dart';
import '../controllers/vi_controller.dart';
import '../models/vi_phan_thuong.dart';
import '../models/khao_sat.dart';

class WalletScreen extends StatefulWidget {
  final int userId;
  const WalletScreen({super.key, required this.userId});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final ViController _viController = ViController();
  List<ViPhanThuong> _rewards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRewards();
  }

  Future<void> _loadRewards() async {
    final rewards = await _viController.getRewardsByUser(widget.userId);
    setState(() {
      _rewards = rewards;
      _isLoading = false;
    });
  }

  Widget _buildRewardIcon(LoaiPhanThuong loai) {
    switch (loai) {
      case LoaiPhanThuong.voucher:
        return const CircleAvatar(
          backgroundColor: Colors.orangeAccent,
          child: Icon(Icons.card_giftcard, color: Colors.white),
        );
      case LoaiPhanThuong.tienMat:
        return const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.attach_money, color: Colors.white),
        );
      case LoaiPhanThuong.diemTichLuy:
        return const CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.stars, color: Colors.white),
        );
      default:
        return const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.help_outline, color: Colors.white),
        );
    }
  }

  String _getRewardTitle(LoaiPhanThuong loai) {
    switch (loai) {
      case LoaiPhanThuong.voucher:
        return "Voucher giảm giá";
      case LoaiPhanThuong.tienMat:
        return "Tiền mặt";
      case LoaiPhanThuong.diemTichLuy:
        return "Điểm tích luỹ";
      default:
        return "Phần thưởng";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rewards.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_balance_wallet_outlined, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        "Ví của bạn đang trống",
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Hãy hoàn thành khảo sát để nhận thưởng nhé!",
                        style: TextStyle(color: Colors.black45),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _rewards.length,
                  itemBuilder: (context, index) {
                    final reward = _rewards[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: _buildRewardIcon(reward.loaiPhanThuong),
                        title: Text(
                          reward.giaTri,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              "Từ: ${reward.tenKhaoSat}",
                              style: const TextStyle(color: Colors.black87),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Nhận lúc: ${reward.ngayNhan.day.toString().padLeft(2, '0')}/${reward.ngayNhan.month.toString().padLeft(2, '0')}/${reward.ngayNhan.year} ${reward.ngayNhan.hour.toString().padLeft(2, '0')}:${reward.ngayNhan.minute.toString().padLeft(2, '0')}",
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0EA5E9).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getRewardTitle(reward.loaiPhanThuong),
                            style: const TextStyle(
                              color: Color(0xFF0EA5E9),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
