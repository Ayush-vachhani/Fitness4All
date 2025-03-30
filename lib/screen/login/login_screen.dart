import 'package:fitness4all/screen/home/Main_home/home_screen.dart';
import 'package:fitness4all/screen/login/registration_screen.dart';
import 'package:fitness4all/services/two_factor_auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitness4all/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  String _errorMessage = '';

  void _login() async {
    try {
      await AuthService.login(_emailController.text, _passwordController.text, rememberMe: _rememberMe);
      final userId = AuthService.userDetails?['id'];
      if (userId != null) {
        // Check if 2FA is enabled
        final response = await http.get(
          Uri.parse('http://0.0.0.0:8090/api/collections/_mfas/records?filter[recordRef]=$userId'),
          headers: {'Authorization': 'Bearer ${await AuthService.getAuthToken()}'},
        );

        if (response.statusCode == 200) {
          final mfaData = json.decode(response.body);
          debugPrint('MFA Data: $mfaData');

          if (mfaData['items'] != null && mfaData['items'].isNotEmpty && mfaData['items'][0]['method'] == 'totp') {
            // Generate and send OTP
            await AuthService.generateAndStoreOtp(userId, _emailController.text);
            // Navigate to 2FA screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TwoFactorAuthScreen(userId: userId)),
            );
            return;
          }
        }
      }
      // No 2FA required, proceed to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      debugPrint('Login Error: $e');
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
              TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value!;
                      });
                    },
                  ),
                  Text('Remember Me'),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _login, child: Text('Login')),
              if (_errorMessage.isNotEmpty) Text(_errorMessage, style: TextStyle(color: Colors.red)),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}