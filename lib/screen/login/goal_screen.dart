/*import 'package:flutter/material.dart';
import 'package:fitness4all/services/auth_service.dart';
import 'package:fitness4all/screen/login/login_screen.dart';

class SelectGoalScreen extends StatefulWidget {
  final String email;
  final String password;
  final String username;
  final String age;
  final String height;
  final String weight;
  final String level;

  SelectGoalScreen({
    required this.email,
    required this.password,
    required this.username,
    required this.age,
    required this.height,
    required this.weight,
    required this.level,
  });

  @override
  _SelectGoalScreenState createState() => _SelectGoalScreenState();
}

class _SelectGoalScreenState extends State<SelectGoalScreen> {
  final _goalController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  void _register() async {
    setState(() {
      _isLoading = true;
    });

    final email = widget.email;
    final password = widget.password;
    final username = widget.username;
    final age = widget.age;
    final height = widget.height;
    final weight = widget.weight;
    final level = widget.level;
    final goal = _goalController.text;

    try {
      await AuthService.register(email, password, username, age, height, weight, level, goal, image);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to register: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Goal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _goalController,
              decoration: InputDecoration(labelText: 'Goal'),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _register,
                child: Text('Register'),
              ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}*/