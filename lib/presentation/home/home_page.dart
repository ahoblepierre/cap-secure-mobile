import 'package:cap_secure_mobile/config/app_style.dart';
import 'package:cap_secure_mobile/config/size_config.dart';
import 'package:cap_secure_mobile/presentation/notification/notifications_page.dart';
import 'package:cap_secure_mobile/presentation/profil/profile_page.dart';
import 'package:cap_secure_mobile/presentation/scanner/scanner_page.dart';
import 'package:cap_secure_mobile/presentation/timetable/timetable_page.dart';
import 'package:cap_secure_mobile/widgets/custom_app_bar.dart';
import 'package:cap_secure_mobile/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const TimetablePage(),
    const ScannerPage(),
    const NotificationsPage(),
    const ProfilePage(),
  ];

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: "Accueil",
        centerTitle: false,
        elevation: 4.0,
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(kpadding),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: _onTabChange,
        activeColor: kBleue,
      ),
    );
  }
}
