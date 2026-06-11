import 'package:flutter/material.dart';

import '../../models/account.dart';
import '../../controllers/UserController.dart';
import '../../utils/app_text.dart';

class ProfilePage extends StatefulWidget {
  final Account account;

  const ProfilePage({
    super.key,
    required this.account,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserController controller = UserController();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController hoTenController;
  late TextEditingController phoneController;
  late TextEditingController queQuanController;
  late TextEditingController ngaySinhController;
  late TextEditingController emailController;
  int gioiTinh = 0;

  @override
  void initState() {
    super.initState();
    hoTenController = TextEditingController(text: widget.account.hoTen);
    phoneController = TextEditingController(text: widget.account.soDienThoai);
    queQuanController = TextEditingController(text: widget.account.queQuan);
    ngaySinhController = TextEditingController(text: widget.account.ngaySinh);
    emailController = TextEditingController(text: widget.account.email);
    gioiTinh = widget.account.gioiTinh;
  }

  @override
  void dispose() {
    hoTenController.dispose();
    phoneController.dispose();
    queQuanController.dispose();
    ngaySinhController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void saveProfile() async {
    if (_formKey.currentState!.validate()) {
      Account updatedAccount = Account(
        id: widget.account.id,
        username: widget.account.username,
        password: widget.account.password,
        hoTen: hoTenController.text.trim(),
        ngaySinh: ngaySinhController.text.trim(),
        gioiTinh: gioiTinh,
        soDienThoai: phoneController.text.trim(),
        email: emailController.text.trim(),
        queQuan: queQuanController.text.trim(),
        role: widget.account.role,
      );

      bool success = await controller.updateUserInfo(updatedAccount);

      if (success) {
        widget.account.hoTen = updatedAccount.hoTen;
        widget.account.ngaySinh = updatedAccount.ngaySinh;
        widget.account.gioiTinh = updatedAccount.gioiTinh;
        widget.account.soDienThoai = updatedAccount.soDienThoai;
        widget.account.email = updatedAccount.email;
        widget.account.queQuan = updatedAccount.queQuan;

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                T.isEnglish
                    ? "Account updated successfully"
                    : "Cập nhật tài khoản thành công",
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                T.isEnglish ? "Update failed" : "Cập nhật thất bại",
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<Locale>(
      valueListenable: T.locale,
      builder: (context, locale, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(T.text("profile")),
            centerTitle: true,
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 48,
                        backgroundColor: Color(0xff08aff0),
                        child: Icon(
                          Icons.person,
                          size: 54,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.account.username,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.account.role == 'Admin'
                            ? 'Quản trị viên'
                            : 'Người dùng',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: hoTenController,
                  decoration: InputDecoration(
                    labelText: T.text("fullName"),
                    filled: true,
                    fillColor: isDark ? Colors.black26 : Colors.white,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Vui lòng nhập họ tên'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: ngaySinhController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Ngày sinh (dd/mm/yyyy)',
                    filled: true,
                    fillColor: isDark ? Colors.black26 : Colors.white,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        ngaySinhController.text =
                            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                      });
                    }
                  },
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Vui lòng chọn ngày sinh'
                      : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: gioiTinh,
                  decoration: InputDecoration(
                    labelText: 'Giới tính',
                    filled: true,
                    fillColor: isDark ? Colors.black26 : Colors.white,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.transgender),
                  ),
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Nam')),
                    DropdownMenuItem(value: 1, child: Text('Nữ')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      if (value != null) gioiTinh = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: T.text("phone"),
                    filled: true,
                    fillColor: isDark ? Colors.black26 : Colors.white,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Vui lòng nhập số điện thoại'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: isDark ? Colors.black26 : Colors.white,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    if (!value.contains('@')) return 'Email không hợp lệ';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: queQuanController,
                  decoration: InputDecoration(
                    labelText: 'Quê quán',
                    filled: true,
                    fillColor: isDark ? Colors.black26 : Colors.white,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Vui lòng nhập quê quán'
                      : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff08aff0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: saveProfile,
                  child: Text(
                    T.text("saveInfo"),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
