import 'package:flutter/material.dart';

import '../../utils/app_state.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isDark = AppState.themeMode.value == ThemeMode.dark;

  void changeTheme(bool value) {
    setState(() {
      isDark = value;
    });

    AppState.changeTheme(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cài đặt"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              title: const Text("Chế độ tối"),
              subtitle: const Text("Áp dụng cho toàn bộ ứng dụng"),
              value: isDark,
              onChanged: changeTheme,
            ),
          ),
        ],
      ),
    );
  }
}
