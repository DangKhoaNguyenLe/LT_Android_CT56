import 'package:flutter/material.dart';
import '../../models/account.dart';
import '../login.dart';
import '../login.dart';
import '../Admin/admin_dashboard.dart';
import '../history.dart';
import '../profile.dart';

class CustomDrawer extends StatelessWidget {
  final Account account;
  final VoidCallback? onReturnFromAdmin;

  const CustomDrawer({super.key, required this.account, this.onReturnFromAdmin});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF0EA5E9),
            ),
            accountName: Text(
              account.hoTen,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text(account.email),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Color(0xFF0EA5E9)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Trang chủ'),
            onTap: () {
              Navigator.pop(context); // Đóng menu
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Lịch sử khảo sát'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen(account: account)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.manage_accounts),
            title: const Text('Quản lý tài khoản'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Quản lý tài khoản'),
                      backgroundColor: const Color(0xFF0EA5E9),
                      foregroundColor: Colors.white,
                    ),
                    body: ProfileScreen(account: account),
                  ),
                ),
              );
            },
          ),
          const Spacer(), // Đẩy các nút bên dưới xuống đáy
          
          if (account.role == 'Admin')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Đóng drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminDashboard(account: account),
                    ),
                  ).then((_) {
                    if (onReturnFromAdmin != null) {
                      onReturnFromAdmin!();
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.admin_panel_settings),
                    SizedBox(width: 8),
                    Text('Trang quản trị', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0).copyWith(bottom: 24.0),
            child: OutlinedButton(
              onPressed: () {
                // Đăng xuất và quay về trang Login
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black87,
                minimumSize: const Size(double.infinity, 45),
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 8),
                  Text('Đăng xuất'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
