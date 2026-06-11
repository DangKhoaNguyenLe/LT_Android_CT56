import 'package:flutter/material.dart';
import '../models/account.dart';
import '../controllers/UserController.dart';

class ProfileScreen extends StatefulWidget {
  final Account account;

  const ProfileScreen({super.key, required this.account});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _hoTenController;
  late TextEditingController _ngaySinhController;
  late TextEditingController _soDienThoaiController;
  late TextEditingController _emailController;
  late TextEditingController _queQuanController;
  int _gioiTinh = 0; // 0: Nam, 1: Nữ

  final UserController _userController = UserController();

  @override
  void initState() {
    super.initState();
    _hoTenController = TextEditingController(text: widget.account.hoTen);
    _ngaySinhController = TextEditingController(text: widget.account.ngaySinh);
    _soDienThoaiController = TextEditingController(text: widget.account.soDienThoai);
    _emailController = TextEditingController(text: widget.account.email);
    _queQuanController = TextEditingController(text: widget.account.queQuan);
    _gioiTinh = widget.account.gioiTinh;
  }

  @override
  void dispose() {
    _hoTenController.dispose();
    _ngaySinhController.dispose();
    _soDienThoaiController.dispose();
    _emailController.dispose();
    _queQuanController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      Account updatedAccount = Account(
        id: widget.account.id,
        username: widget.account.username,
        password: widget.account.password,
        hoTen: _hoTenController.text,
        ngaySinh: _ngaySinhController.text,
        gioiTinh: _gioiTinh,
        soDienThoai: _soDienThoaiController.text,
        email: _emailController.text,
        queQuan: _queQuanController.text,
        role: widget.account.role,
      );

      bool success = await _userController.updateUserInfo(updatedAccount);
      if (success) {
        // Cập nhật lại đối tượng account trên bộ nhớ (tránh bị lệch dữ liệu)
        widget.account.hoTen = _hoTenController.text;
        widget.account.ngaySinh = _ngaySinhController.text;
        widget.account.gioiTinh = _gioiTinh;
        widget.account.soDienThoai = _soDienThoaiController.text;
        widget.account.email = _emailController.text;
        widget.account.queQuan = _queQuanController.text;

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cập nhật thông tin thành công')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cập nhật thất bại')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              widget.account.username,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.account.role == 'Admin' ? 'Quản trị viên' : 'Người dùng',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _hoTenController,
              decoration: InputDecoration(
                labelText: 'Họ và tên',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.person_outline),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập họ tên' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ngaySinhController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Ngày sinh (dd/mm/yyyy)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                    _ngaySinhController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                  });
                }
              },
              validator: (value) => value == null || value.trim().isEmpty ? 'Vui lòng chọn ngày sinh' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _gioiTinh,
              decoration: InputDecoration(
                labelText: 'Giới tính',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.transgender),
              ),
              items: const [
                DropdownMenuItem(value: 0, child: Text('Nam')),
                DropdownMenuItem(value: 1, child: Text('Nữ')),
              ],
              onChanged: (value) {
                setState(() {
                  if (value != null) _gioiTinh = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _soDienThoaiController,
              decoration: InputDecoration(
                labelText: 'Số điện thoại',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) => value == null || value.trim().isEmpty ? 'Vui lòng nhập số điện thoại' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Vui lòng nhập email';
                if (!value.contains('@')) return 'Email không hợp lệ';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _queQuanController,
              decoration: InputDecoration(
                labelText: 'Quê quán',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.location_on),
              ),
              validator: (value) => value == null || value.trim().isEmpty ? 'Vui lòng nhập quê quán' : null,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Cập nhật thông tin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
