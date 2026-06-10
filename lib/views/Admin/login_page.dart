import 'package:flutter/material.dart';
import 'admin_dashboard.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void login(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const AdminDashboard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xffd9d9d9),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.admin_panel_settings,
                    size: 70,
                    color: Color(0xff08aff0),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Đăng nhập Admin",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: "Tên đăng nhập",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Mật khẩu",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff08aff0),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 46),
                    ),
                    onPressed: () => login(context),
                    child: const Text("Đăng nhập"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
