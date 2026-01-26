import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? gap;
  final double? iconSize;
  final double? padding;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
    this.backgroundColor = Colors.white,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.gap = 8.0,
    this.iconSize = 24.0,
    this.padding = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withValues(alpha: 0.1)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: GNav(
            gap: gap!,
            activeColor: activeColor,
            iconSize: iconSize,
            padding: EdgeInsets.symmetric(horizontal: padding!, vertical: 12.0),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: activeColor!.withValues(alpha: 0.1),
            color: inactiveColor,
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
            tabs: const [
              GButton(
                icon: HugeIcons.strokeRoundedCalendar02,
                text: 'Emploi du temps',
              ),
              GButton(icon: HugeIcons.strokeRoundedQrCode, text: 'Pointage'),
              GButton(
                icon: HugeIcons.strokeRoundedNotification01,
                text: 'Notifications',
              ),
              GButton(icon: HugeIcons.strokeRoundedUser, text: 'Profil'),
            ],
          ),
        ),
      ),
    );
  }
}
