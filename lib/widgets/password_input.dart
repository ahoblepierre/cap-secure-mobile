import 'package:cap_secure_mobile/config/app_style.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

// ignore: must_be_immutable
class PasswordInput extends StatefulWidget {
  const PasswordInput({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
  });

  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        label: Text(widget.labelText ?? ""),
        hint: Text(widget.hintText ?? ""),
        prefixIcon: Icon(HugeIcons.strokeRoundedSquareLock02),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          child: Icon(
            obscureText ? Icons.visibility_off : HugeIcons.strokeRoundedView,
          ),
        ),
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
          return "${widget.labelText} est requis";
        }
        return null;
      },
    );
  }
}
// remove_red_eye_rounded