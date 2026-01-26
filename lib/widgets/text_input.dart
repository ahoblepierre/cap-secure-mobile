import 'package:cap_secure_mobile/config/app_style.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class TextInput extends StatelessWidget {
  const TextInput({super.key, this.labelText, this.hintText});

  final String? labelText;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: Text(labelText ?? ""),
        hint: Text(hintText ?? ""),
        prefixIcon: Icon(HugeIcons.strokeRoundedUser, color: Colors.black),
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
