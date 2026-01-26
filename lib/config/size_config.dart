import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeigth;
  static double? blockHorizontal;
  static double? blockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeigth = _mediaQueryData!.size.height;
    blockHorizontal = screenHeigth! / 100;
    blockVertical = screenHeigth! / 100;
  }
}
