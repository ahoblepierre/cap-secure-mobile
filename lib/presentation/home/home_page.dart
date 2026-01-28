import 'package:cap_secure_mobile/config/app_style.dart';
import 'package:cap_secure_mobile/config/size_config.dart';
import 'package:cap_secure_mobile/presentation/notification/notifications_page.dart';
import 'package:cap_secure_mobile/presentation/profil/profile_page.dart';
import 'package:cap_secure_mobile/presentation/scanner/scanner_page.dart';
import 'package:cap_secure_mobile/presentation/timetable/timetable_page.dart';
import 'package:cap_secure_mobile/routes/routes.dart';
import 'package:cap_secure_mobile/widgets/custom_app_bar.dart';
import 'package:cap_secure_mobile/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

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

  final List<String> _pageTitles = [
    "Emploi du temps",
    "Pointage",
    "Notifications",
    "Profil",
  ];

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          title: const Text(
            'Confirmer la déconnexion',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          content: const Text(
            'Êtes-vous sûr de vouloir vous déconnecter ?',
            style: TextStyle(color: Colors.black54),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Annuler',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                final box = GetStorage();
                box.erase();
                context.go(Routes.login);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child: const Text('Déconnexion'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: _pageTitles[_selectedIndex],
        centerTitle: false,
        elevation: 4.0,
        actions: _selectedIndex == 3
            ? [
                IconButton(
                  icon: const Icon(Icons.login_outlined),
                  onPressed: () {
                    _showLogoutConfirmation();
                  },
                ),
              ]
            : null,
      ),
      body: SafeArea(
        // minimum: EdgeInsets.all(kpadding),
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
