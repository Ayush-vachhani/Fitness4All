import 'package:flutter/material.dart';
import 'package:fitness4all/services/auth_service.dart';

class DeleteAccountScreen extends StatelessWidget {
  final String userId;

  DeleteAccountScreen({required this.userId});

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      await AuthService.deleteUser(userId);
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Are you sure you want to delete your account? This action cannot be undone.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _deleteAccount(context),
              child: Text('Delete Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}