// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:fitness4all/services/auth_service.dart';
import 'package:fitness4all/screen/home/Main_home/home_screen.dart';
import 'package:fitness4all/screen/login/login_screen.dart';

class RememberMeCheckScreen extends StatefulWidget {
  @override
  _RememberMeCheckScreenState createState() => _RememberMeCheckScreenState();
}

class _RememberMeCheckScreenState extends State<RememberMeCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await AuthService.getAuthToken();
    final rememberMe = await AuthService.isRememberMeEnabled();

    if (token != null && rememberMe) {
      // Fetch user details using the stored token
      try {
        await AuthService.fetchUserDetails(AuthService.userDetails!['id'], token);
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}