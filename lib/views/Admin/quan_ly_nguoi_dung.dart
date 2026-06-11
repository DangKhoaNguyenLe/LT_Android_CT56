import 'package:flutter/material.dart';
import '../../controllers/UserController.dart';
import '../../models/account.dart';

class ManageUserScreen extends StatefulWidget {
  const ManageUserScreen({super.key});

  @override
  State<ManageUserScreen> createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends State<ManageUserScreen> {
  final UserController _userController = UserController();
  List<Account> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await _userController.getAllUsers();
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  void _showEditDialog(Account user) {
    final TextEditingController hoTenController = TextEditingController(text: user.hoTen);
    final TextEditingController emailController = TextEditingController(text: user.email);
    final TextEditingController phoneController = TextEditingController(text: user.soDienThoai);
    final TextEditingController usernameController = TextEditingController(text: user.username);
    final TextEditingController passwordController = TextEditingController(text: user.password);
    final TextEditingController ngaySinhController = TextEditingController(text: user.ngaySinh);
    final TextEditingController queQuanController = TextEditingController(text: user.queQuan);
    int selectedGioiTinh = user.gioiTinh;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sửa thông tin tài khoản'),
        content: StatefulBuilder(
          builder: (context, setStateDialog) => Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên đăng nhập',
                      filled: true,
                      fillColor: Color(0xFFEEEEEE),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Mật khẩu'),
                    obscureText: true,
                    validator: (value) => value == null || value.trim().isEmpty ? 'Vui lòng nhập mật khẩu' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: hoTenController,
                    decoration: const InputDecoration(labelText: 'Họ và tên'),
                    validator: (value) => value == null || value.trim().isEmpty ? 'Vui lòng nhập họ tên' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Vui lòng nhập email';
                      if (!value.contains('@')) return 'Email không hợp lệ';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Số điện thoại'),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value == null || value.trim().isEmpty ? 'Vui lòng nhập SĐT' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: ngaySinhController,
                    decoration: const InputDecoration(labelText: 'Ngày sinh (dd/mm/yyyy)'),
                    readOnly: true,
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setStateDialog(() {
                          ngaySinhController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                        });
                      }
                    },
                    validator: (value) => value == null || value.trim().isEmpty ? 'Vui lòng chọn ngày sinh' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: queQuanController,
                    decoration: const InputDecoration(labelText: 'Quê quán'),
                    validator: (value) => value == null || value.trim().isEmpty ? 'Vui lòng nhập quê quán' : null,
                  ),
                const SizedBox(height: 10),
                DropdownButtonFormField<int>(
                  value: selectedGioiTinh,
                  decoration: const InputDecoration(labelText: 'Giới tính'),
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('Nam')),
                    DropdownMenuItem(value: 1, child: Text('Nữ')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setStateDialog(() {
                        selectedGioiTinh = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Account updatedAccount = Account(
                  id: user.id,
                  username: usernameController.text,
                  password: passwordController.text,
                  hoTen: hoTenController.text,
                  ngaySinh: ngaySinhController.text,
                  gioiTinh: selectedGioiTinh,
                  soDienThoai: phoneController.text,
                  email: emailController.text,
                  queQuan: queQuanController.text,
                  role: user.role,
                );
                bool success = await _userController.updateUserInfo(updatedAccount);
                if (success) {
                  await _loadUsers();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cập nhật thành công!')),
                    );
                  }
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lỗi cập nhật dữ liệu!')),
                    );
                  }
                }
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _deleteUser(Account user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa tài khoản ${user.username}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              if (user.id != null) {
                await _userController.deleteUser(user.id!);
                _loadUsers();
              }
              Navigator.pop(context);
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
      appBar: AppBar(
        title: const Text('Quản lý Người Dùng'),
        backgroundColor: const Color(0xFF0EA5E9),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? const Center(child: Text("Không có người dùng nào"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF0EA5E9),
                          child: Text(
                            user.hoTen.isNotEmpty ? user.hoTen[0].toUpperCase() : 'U',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(user.hoTen.isEmpty ? user.username : user.hoTen),
                        subtitle: Text('Username: ${user.username}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => _showEditDialog(user),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteUser(user),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
