import 'package:cap_secure_mobile/config/app_style.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.labelText,
    this.backgroundColor = kBleue,
    this.onPress,
  });

  final String labelText;
  final Color? backgroundColor;
  final void Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.all(20),
          shape: ContinuousRectangleBorder(),
          textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          foregroundColor: Colors.white,
        ),
        child: Text(labelText),
      ),
    );
  }
}
