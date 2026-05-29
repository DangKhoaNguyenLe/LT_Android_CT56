import 'package:flutter/material.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_bottom_nav.dart';
import 'widgets/custom_drawer.dart';
import '../models/account.dart';
import 'home.dart';

class MainLayout extends StatefulWidget {
  final Account account;

  const MainLayout({super.key, required this.account});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const Center(child: Text("Thống kê (Coming soon)")),
    const Center(child: Text("Tài khoản (Coming soon)")),
  ];

  final List<String> _titles = [
    'Quản lí khảo sát',
    'Thống kê & Báo cáo',
    'Tài khoản của tôi',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: _titles[_currentIndex]),
      drawer: CustomDrawer(account: widget.account),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
