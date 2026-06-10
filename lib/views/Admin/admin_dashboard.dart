import 'package:flutter/material.dart';
import '../../controllers/khao_sat_controller.dart';
import '../../controllers/admin_user_controller.dart';
import '../../models/khao_sat.dart';

import 'manage_survey.dart';
import 'create_survey.dart';
import 'profile_page.dart';
import 'setting_page.dart';
import 'login_page.dart';
import 'statistics.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final KhaoSatController controller = KhaoSatController();
  final AdminUserController adminUserController = AdminUserController();
  final TextEditingController searchController = TextEditingController();

  List<KhaoSat> surveys = [];
  int? selectedMonth;
  bool isLocked = true;

  @override
  void initState() {
    super.initState();

    surveys = controller.getLatestFiveSurveys();
    isLocked = adminUserController.isProfileLocked();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkFirstSetup();
    });
  }

  void checkFirstSetup() {
    if (adminUserController.isProfileLocked()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Cần thiết lập tài khoản"),
          content: const Text(
            "Lần đầu đăng nhập, bạn phải nhập biệt danh hiển thị. "
            "Nếu chưa có biệt danh, các chức năng quản lý khảo sát sẽ tạm thời bị khóa.",
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfilePage(isRequiredSetup: true),
                  ),
                );

                refreshData();
              },
              child: const Text("Thiết lập ngay"),
            ),
          ],
        ),
      );
    }
  }

  void refreshData() {
    setState(() {
      surveys = controller.getLatestFiveSurveys();
      searchController.clear();
      selectedMonth = null;
      isLocked = adminUserController.isProfileLocked();
    });
  }

  void showLockedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Chức năng đang bị khóa. Vui lòng thiết lập biệt danh hiển thị trước.",
        ),
      ),
    );
  }

  void searchSurvey() {
    if (isLocked) {
      return;
    }

    setState(() {
      surveys = controller.searchByName(searchController.text);
    });
  }

  void filterByMonth(int? month) {
    if (isLocked) {
      showLockedMessage();
      return;
    }

    setState(() {
      selectedMonth = month;

      if (month == null) {
        surveys = controller.getLatestFiveSurveys();
      } else {
        surveys = controller.searchByMonth(month);
      }
    });
  }

  Future<void> openManageSurvey() async {
    if (isLocked) {
      showLockedMessage();
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ManageSurveyPage(),
      ),
    );

    refreshData();
  }

  Future<void> openCreateSurvey() async {
    if (isLocked) {
      showLockedMessage();
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateSurveyPage(),
      ),
    );

    refreshData();
  }

  Future<void> openProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfilePage(),
      ),
    );

    refreshData();
  }

  Future<void> openSetting() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SettingPage(),
      ),
    );

    setState(() {});
  }

  void openStatistics() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const StatisticsPage(),
      ),
    );
  }

  void logout() {
    adminUserController.logout();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
    );
  }

  Color getStatusColor(KhaoSat survey) {
    switch (survey.trangThai) {
      case TrangThaiKhaoSat.banNhap:
        return Colors.orange;
      case TrangThaiKhaoSat.dangMo:
        return const Color(0xff08aff0);
      case TrangThaiKhaoSat.daDong:
        return Colors.grey;
    }
  }

  String getStatusText(KhaoSat survey) {
    switch (survey.trangThai) {
      case TrangThaiKhaoSat.banNhap:
        return "Bản nháp";
      case TrangThaiKhaoSat.dangMo:
        return "Đang mở";
      case TrangThaiKhaoSat.daDong:
        return "Đã đóng";
    }
  }

  Widget buildAdminDrawer() {
    final profile = adminUserController.getProfile();

    final String displayName = profile.bietDanh.trim().isEmpty
        ? "Chưa thiết lập biệt danh"
        : profile.bietDanh.trim();

    return Drawer(
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              Navigator.pop(context);
              await openProfile();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 48,
                bottom: 22,
                left: 16,
                right: 16,
              ),
              color: const Color(0xff08aff0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white,
                    child: profile.avatar.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Color(0xff08aff0),
                          )
                        : const Icon(
                            Icons.image,
                            size: 50,
                            color: Color(0xff08aff0),
                          ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    displayName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Nhấn để xem tài khoản",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text("Quản lý khảo sát"),
            onTap: () {
              Navigator.pop(context);
              openManageSurvey();
            },
          ),

          ListTile(
            leading: const Icon(Icons.analytics_outlined),
            title: const Text("Phân tích khảo sát"),
            onTap: () {
              Navigator.pop(context);
              openStatistics();
            },
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Cài đặt"),
            onTap: () {
              Navigator.pop(context);
              openSetting();
            },
          ),

          const Spacer(),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Đăng xuất",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              logout();
            },
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildLockedBox() {
    if (!isLocked) {
      return const SizedBox();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock, color: Colors.orange),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              "Tài khoản chưa có biệt danh hiển thị. "
              "Các chức năng tạo, sửa, xóa khảo sát đang bị khóa.",
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: openProfile,
            child: const Text("Cập nhật"),
          ),
        ],
      ),
    );
  }

  Widget buildSurveyCard(KhaoSat survey) {
    return Opacity(
      opacity: isLocked ? 0.45 : 1,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.black54),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: getStatusColor(survey),
                child: const Icon(
                  Icons.assignment,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      survey.tenKhaoSat,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      survey.moTa,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Danh mục khảo sát: ${survey.danhMuc?.tenDanhMuc ?? "Chưa chọn"}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),

                    Text(
                      "Ngày tạo: ${survey.ngayTao.day}/${survey.ngayTao.month}/${survey.ngayTao.year}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),

                    Text(
                      "Phần thưởng: ${survey.getPhanThuongText()}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: getStatusColor(survey),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  getStatusText(survey),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmptyBox() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "Chưa có khảo sát nào",
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text(
          "Quản lí khảo sát",
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
      ),

      drawer: buildAdminDrawer(),

      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            buildLockedBox(),

            TextField(
              controller: searchController,
              enabled: !isLocked,
              onChanged: (_) => searchSurvey(),
              decoration: InputDecoration(
                hintText: "Tìm khảo sát theo tên",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDark ? Colors.black26 : Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<int?>(
              value: selectedMonth,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? Colors.black26 : Colors.white,
                labelText: "Tìm kiếm theo tháng",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text("Tất cả tháng"),
                ),
                ...List.generate(
                  12,
                  (index) => DropdownMenuItem<int?>(
                    value: index + 1,
                    child: Text("Tháng ${index + 1}"),
                  ),
                ),
              ],
              onChanged: isLocked ? null : filterByMonth,
            ),

            const SizedBox(height: 16),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "5 khảo sát tạo gần nhất",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: surveys.isEmpty
                  ? buildEmptyBox()
                  : ListView.builder(
                      itemCount: surveys.length,
                      itemBuilder: (context, index) {
                        return buildSurveyCard(surveys[index]);
                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: openCreateSurvey,
        child: Icon(
          isLocked ? Icons.lock : Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
