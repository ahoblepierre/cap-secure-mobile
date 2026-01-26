import 'package:cap_secure_mobile/config/app_style.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

// ignore: must_be_immutable
class PasswordInput extends StatelessWidget {
  PasswordInput({super.key, this.labelText, this.hintText});

  final String? labelText;
  final String? hintText;

  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        label: Text(labelText ?? ""),
        hint: Text(hintText ?? ""),
        prefixIcon: Icon(HugeIcons.strokeRoundedSquareLock02),
        suffixIcon: GestureDetector(
          onTap: () {
            obscureText = !obscureText;
          },
          child: Icon(
            obscureText ? Icons.visibility_off : HugeIcons.strokeRoundedView,
          ),
        ),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kGrey)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: kGrey)),
      ),
      validator: (value) {
        if (value == null) {
          return "$labelText est requis";
        }
        return null;
      },
    );
  }
}
// remove_red_eye_rounded