import 'package:flutter/material.dart';
import '../controllers/khao_sat_controller.dart';
import '../controllers/lich_su_controller.dart';
import 'survey_detail.dart';
import '../models/khao_sat.dart';
import '../models/account.dart';

class HomeScreen extends StatefulWidget {
  final Account account;
  const HomeScreen({super.key, required this.account});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final KhaoSatController _khaoSatController = KhaoSatController();
  List<KhaoSat> _surveys = [];

  @override
  void initState() {
    super.initState();
    _loadSurveys();
  }

  Future<void> _loadSurveys() async {
    int currentUserId = widget.account.id ?? 1; 
    final lichSuController = LichSuController();
    final allSurveys = await _khaoSatController.getAll();
    List<KhaoSat> result = [];
    for(var survey in allSurveys) {
      bool isClosedByLimit = (survey.gioiHanNguoiThamGia != null &&
          survey.gioiHanNguoiThamGia! > 0 &&
          survey.soNguoiThamGia >= survey.gioiHanNguoiThamGia!);

      if(survey.trangThai == TrangThaiKhaoSat.dangMo && !isClosedByLimit && !(await lichSuController.hasUserCompletedSurvey(currentUserId, survey.id))) {
        result.add(survey);
      }
    }
    setState(() {
      _surveys = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), 
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Tìm khảo sát',
                  hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.black87),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (value) async {
                  int currentUserId = widget.account.id ?? 1;
                  final lichSuController = LichSuController();
                  List<KhaoSat> fetchedSurveys = value.isEmpty 
                      ? await _khaoSatController.getAll() 
                      : await _khaoSatController.searchByName(value);
                  
                  List<KhaoSat> result = [];
                  for(var survey in fetchedSurveys) {
                    if(survey.trangThai == TrangThaiKhaoSat.dangMo && !(await lichSuController.hasUserCompletedSurvey(currentUserId, survey.id))) {
                      result.add(survey);
                    }
                  }
                  
                  setState(() {
                    _surveys = result;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            
            Expanded(
              child: _surveys.isEmpty
                  ? const Center(child: Text("Không có bài khảo sát nào"))
                  : ListView.separated(
                      itemCount: _surveys.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final survey = _surveys[index];

                        return InkWell(
                          onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SurveyDetailScreen(survey: survey, account: widget.account),
                                    ),
                                  );
                                  _loadSurveys();
                                },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  survey.tenKhaoSat,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  survey.moTa ?? "Không có mô tả",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${survey.cauHois.length} câu hỏi',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0EA5E9),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        "Tham gia",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _loadSurveys();
        },
        backgroundColor: const Color(0xFF0EA5E9),
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
