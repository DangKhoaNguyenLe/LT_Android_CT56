import 'package:flutter/material.dart';
import '../controllers/lich_su_controller.dart';
import '../controllers/khao_sat_controller.dart';
import '../models/lich_su_khao_sat.dart';
import '../models/khao_sat.dart';
import 'history_detail.dart';
import '../models/account.dart';

class HistoryScreen extends StatefulWidget {
  final Account account;
  const HistoryScreen({super.key, required this.account});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final LichSuController _lichSuController = LichSuController();
  final KhaoSatController _khaoSatController = KhaoSatController();
  late Future<List<LichSuKhaoSat>> _futureLichSu;

  @override
  void initState() {
    super.initState();
    _futureLichSu = _lichSuController.getLichSuByUser(widget.account.id ?? 1); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử làm bài'),
        backgroundColor: const Color(0xFF0EA5E9),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<LichSuKhaoSat>>(
        future: _futureLichSu,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Bạn chưa làm bài khảo sát nào"));
          }

          final lichSus = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: lichSus.length,
            itemBuilder: (context, index) {
              final lichSu = lichSus[index];
              return FutureBuilder<KhaoSat?>(
                future: _khaoSatController.getById(lichSu.idKhaoSat),
                builder: (context, ksSnapshot) {
                  final khaoSat = ksSnapshot.data;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(Icons.history, color: Color(0xFF0EA5E9)),
                      title: Text(khaoSat?.tenKhaoSat ?? "Khảo sát #${lichSu.idKhaoSat}"),
                      subtitle: Text('Ngày làm: ${lichSu.ngayLam.day}/${lichSu.ngayLam.month}/${lichSu.ngayLam.year} ${lichSu.ngayLam.hour}:${lichSu.ngayLam.minute.toString().padLeft(2, '0')}'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        if (khaoSat != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HistoryDetailScreen(
                                khaoSat: khaoSat,
                                lichSu: lichSu,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
