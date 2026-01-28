import 'package:cap_secure_mobile/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class CustomDialog {
  static void showErrorDialog(
    BuildContext context, {
    required String message,
    String title = 'Erreur',
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          title: Text(
            title,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: Text(message, style: TextStyle(color: Colors.black87)),
          actions: [
            PrimaryButton(
              onPress: onPressed ?? () => Navigator.of(context).pop(),
              labelText: buttonText,
              backgroundColor: Colors.red,
            ),
          ],
        );
      },
    );
  }

  static void showSuccessDialog(
    BuildContext context, {
    required String message,
    String title = 'Succès',
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          title: Text(
            title,
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
          content: Text(message, style: TextStyle(color: Colors.black87)),
          actions: [
            PrimaryButton(
              onPress: onPressed ?? () => Navigator.of(context).pop(),
              labelText: buttonText,
              backgroundColor: Colors.green,
            ),
          ],
        );
      },
    );
  }

  static void showWarningDialog(
    BuildContext context, {
    required String message,
    String title = 'Attention',
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          title: Text(
            title,
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
          content: Text(message, style: TextStyle(color: Colors.black87)),
          actions: [
            PrimaryButton(
              onPress: onPressed ?? () => Navigator.of(context).pop(),
              labelText: buttonText,
              backgroundColor: Colors.orange,
            ),
          ],
        );
      },
    );
  }
}
