import 'package:flutter/material.dart';
import 'package:fitness4all/screen/login/login_screen.dart';
import 'package:fitness4all/services/auth_service.dart';

class Logout {
  static void performLogout(BuildContext context) {
    AuthService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }
}