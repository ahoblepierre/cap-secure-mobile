import 'package:cap_secure_mobile/config/app_style.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class TextInput extends StatelessWidget {
  const TextInput({super.key, this.labelText, this.hintText, this.controller});

  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        label: Text(labelText ?? ""),
        hint: Text(hintText ?? ""),
        prefixIcon: Icon(HugeIcons.strokeRoundedUser, color: Colors.black),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kGrey)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: kGrey)),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$labelText est requis";
        }
        return null;
      },
    );
  }
}
