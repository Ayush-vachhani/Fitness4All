import 'package:flutter/material.dart';

class TColor {
  // Use full 8-digit hex values (including alpha channel)
  static Color get primary => const Color(0xFF3399FF);
  static Color get secondary => const Color(0xFF3399FF);
  static  Color primaryColor = Color(0xff156C78);
  static  Color secondaryColor = Color(0xffFB784E);

  // Blue
  static Color get primaryText => const Color(0xff0C0B0B); // Black
  static Color get secondaryText => const Color(0xff2C3E50);
  static Color get btnprimaryText => const Color(0xff0D0C0C); // Black
  static Color get btnSecondaryText => const Color(0xff241111); // Black
  static Color get btnNavColor => const Color(0xff33ceff);
  
  static Color get board => const Color(0xffD4D4D4); // Blue
  static Color get txtBG => const Color(0xffFCFBFB); // Gray
  static Color get inactive => primaryText.withOpacity(0.2);
  static Color get placeholder => const Color(0xff94A5A6);// Black with opacity
}

extension AppContext on BuildContext {
  Size get size => MediaQuery.sizeOf(this);
  double get width => size.width;
  double get height => size.height;

  Future push(Widget widget) async {
    return Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  Future pop() async {
    return Navigator.pop(this);
  }
}