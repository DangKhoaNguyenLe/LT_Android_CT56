import 'package:flutter/material.dart';
import '../models/khao_sat.dart';
import 'do_survey.dart';
import '../controllers/lich_su_controller.dart';

import '../models/account.dart';

class SurveyDetailScreen extends StatelessWidget {
  final KhaoSat survey;
  final Account account;

  const SurveyDetailScreen({super.key, required this.survey, required this.account});

  @override
  Widget build(BuildContext context) {
    int currentUserId = account.id ?? 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết khảo sát'),
        backgroundColor: const Color(0xFF0EA5E9),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<bool>(
        future: LichSuController().hasUserCompletedSurvey(currentUserId, survey.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          bool isCompleted = snapshot.data ?? false;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  survey.tenKhaoSat,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Mô tả:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  survey.moTa.isEmpty ? "Không có mô tả" : survey.moTa,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  "Số lượng câu hỏi: ${survey.cauHois.length}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCompleted ? Colors.grey : const Color(0xFF0EA5E9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: isCompleted
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoSurveyScreen(survey: survey, account: account),
                              ),
                            );
                          },
                    child: Text(
                      isCompleted ? 'Bạn đã tham gia khảo sát này' : 'Bắt đầu làm',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
