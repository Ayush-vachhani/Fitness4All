import 'package:flutter/material.dart';
import 'package:fitness4all/screen/login/select_level_screen.dart';

class SelectWeightScreen extends StatefulWidget {
  final String email;
  final String password;
  final String username;
  final String age;
  final String height;

  SelectWeightScreen({
    required this.email,
    required this.password,
    required this.username,
    required this.age,
    required this.height,
  });

  @override
  _SelectWeightScreenState createState() => _SelectWeightScreenState();
}

class _SelectWeightScreenState extends State<SelectWeightScreen> {
  final _weightController = TextEditingController();

  void _next() {
    final weight = _weightController.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectLevelScreen(
          email: widget.email,
          password: widget.password,
          username: widget.username,
          age: widget.age,
          height: widget.height,
          weight: weight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Weight'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _next,
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}