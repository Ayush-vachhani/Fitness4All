import 'package:flutter/material.dart';
import 'package:fitness4all/services/auth_service.dart';

class TwoFactorAuthScreen extends StatefulWidget {
  final String userId;

  const TwoFactorAuthScreen({required this.userId});

  @override
  _TwoFactorAuthScreenState createState() => _TwoFactorAuthScreenState();
}

class _TwoFactorAuthScreenState extends State<TwoFactorAuthScreen> {
  final _otpController = TextEditingController();
  String _errorMessage = '';

  Future<void> _verify2FA() async {
    try {
      await AuthService.verifyTwoFactorAuth(widget.userId, _otpController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('2FA verified successfully.')),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Two-Factor Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(labelText: 'Enter OTP'),
            ),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ElevatedButton(
              onPressed: _verify2FA,
              child: const Text('Verify 2FA'),
            ),
          ],
        ),
      ),
    );
  }
}