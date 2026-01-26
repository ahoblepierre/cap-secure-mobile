import 'package:cap_secure_mobile/config/app_style.dart';
import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPress;
  final double? width;
  final double? height;
  final double iconSize;
  final double fontSize;
  final Color? textColor;
  final FontWeight? fontWeight;

  const IconTextButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPress,
    this.width,
    this.height,
    this.iconSize = 30.0,
    this.fontSize = 16.0,
    this.textColor = Colors.white,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        width: width ?? 80.0,
        height: height ?? 80.0,
        decoration: BoxDecoration(
          color: kBleue,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: kBleue.withValues(alpha: 0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Icon(icon, color: textColor, size: iconSize),
          ],
        ),
      ),
    );
  }
}
