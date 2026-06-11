import 'package:flutter/material.dart';
import 'widgets/thanh_tieu_de.dart';
import 'widgets/thanh_dieu_huong.dart';
import 'widgets/menu_ben.dart';
import '../models/account.dart';
import 'trang_chu.dart';
import 'ho_so.dart';
import 'vi_tien.dart';

class MainLayout extends StatefulWidget {
  final Account account;

  const MainLayout({super.key, required this.account});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  Key _homeKey = UniqueKey();

  void _reloadHome() {
    setState(() {
      _homeKey = UniqueKey();
    });
  }

  List<Widget> get _pages => [
    HomeScreen(key: _homeKey, account: widget.account),
    WalletScreen(userId: widget.account.id ?? 1),
    ProfileScreen(account: widget.account),
  ];

  final List<String> _titles = [
    'Quản lí khảo sát',
    'Ví phần thưởng',
    'Tài khoản của tôi',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: _titles[_currentIndex]),
      drawer: CustomDrawer(
        account: widget.account,
        onReturnFromAdmin: _reloadHome,
      ),
      body: _pages[_currentIndex],
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
