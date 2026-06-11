import 'package:flutter/material.dart';
import '../../controllers/khao_sat_controller.dart';
import '../../controllers/admin_user_controller.dart';
import '../../controllers/UserController.dart';
import '../../models/khao_sat.dart';

import 'manage_survey.dart';
import 'create_survey.dart';
import 'profile_page.dart';
import 'setting_page.dart';
import '../login.dart';
import 'statistics.dart';
import 'manage_user.dart';
import 'manage_category.dart';
import 'manage_reward.dart';
import 'survey_preview.dart';
import '../home.dart';
import '../profile.dart';
import '../../models/account.dart';

class AdminDashboard extends StatefulWidget {
  final Account account;
  const AdminDashboard({super.key, required this.account});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final KhaoSatController controller = KhaoSatController();
  final TextEditingController searchController = TextEditingController();

  List<KhaoSat> surveys = [];
  int? selectedMonth;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  Future<void> refreshData() async {
    final fetchedSurveys = await controller.getLatestFiveSurveys();
    setState(() {
      surveys = fetchedSurveys;
      searchController.clear();
      selectedMonth = null;
    });
  }

  Future<void> searchSurvey() async {
    final fetchedSurveys = await controller.searchByName(searchController.text);
    setState(() {
      surveys = fetchedSurveys;
    });
  }

  Future<void> filterByMonth(int? month) async {

    final fetchedSurveys = month == null 
        ? await controller.getLatestFiveSurveys() 
        : await controller.searchByMonth(month);

    setState(() {
      selectedMonth = month;
      surveys = fetchedSurveys;
    });
  }

  Future<void> openManageSurvey() async {

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ManageSurveyPage(),
      ),
    );

    refreshData();
  }

  Future<void> openCreateSurvey() async {

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
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text('Quản lý tài khoản'),
            backgroundColor: const Color(0xFF0EA5E9),
            foregroundColor: Colors.white,
          ),
          body: ProfileScreen(account: widget.account),
        ),
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  Color getStatusColor(KhaoSat survey) {
    if (survey.trangThai == TrangThaiKhaoSat.dangMo &&
        survey.gioiHanNguoiThamGia != null &&
        survey.gioiHanNguoiThamGia! > 0 &&
        survey.soNguoiThamGia >= survey.gioiHanNguoiThamGia!) {
      return Colors.grey;
    }

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
    if (survey.trangThai == TrangThaiKhaoSat.dangMo &&
        survey.gioiHanNguoiThamGia != null &&
        survey.gioiHanNguoiThamGia! > 0 &&
        survey.soNguoiThamGia >= survey.gioiHanNguoiThamGia!) {
      return "Đã đủ SL";
    }

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
    final String displayName = widget.account.hoTen.trim().isEmpty
        ? widget.account.username
        : widget.account.hoTen.trim();

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
                  const CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Color(0xff08aff0),
                    )
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
            leading: const Icon(Icons.people),
            title: const Text("Quản lý người dùng"),
            onTap: () async {
              Navigator.pop(context);
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageUserScreen()));
              
              // Cập nhật lại thông tin account đang đăng nhập phòng khi Admin tự sửa tài khoản của mình
              if (widget.account.id != null) {
                final UserController userController = UserController();
                final updatedAcc = await userController.getUserById(widget.account.id!);
                if (updatedAcc != null) {
                  setState(() {
                    widget.account.hoTen = updatedAcc.hoTen;
                    widget.account.email = updatedAcc.email;
                    widget.account.soDienThoai = updatedAcc.soDienThoai;
                    widget.account.ngaySinh = updatedAcc.ngaySinh;
                    widget.account.gioiTinh = updatedAcc.gioiTinh;
                    widget.account.queQuan = updatedAcc.queQuan;
                    widget.account.role = updatedAcc.role;
                  });
                }
              }
            },
          ),

          ListTile(
            leading: const Icon(Icons.category),
            title: const Text("Quản lý danh mục"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageCategoryScreen()));
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
            leading: const Icon(Icons.wallet_giftcard),
            title: const Text("Quản lý phần thưởng"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageRewardScreen()));
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
            leading: const Icon(Icons.home, color: Colors.blue),
            title: const Text(
              "Về trang chủ",
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () {
              Navigator.pop(context); // Đóng Drawer
              Navigator.pop(context); // Đóng AdminDashboard, trở về MainLayout
            },
          ),

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
    return const SizedBox();
  }

  Widget buildSurveyCard(KhaoSat survey) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SurveyPreviewPage(khaoSat: survey),
            ),
          );
        },
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
              onChanged: filterByMonth,
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
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
