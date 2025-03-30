import 'package:fitness4all/screen/login/goal_screen.dart';
import 'package:flutter/material.dart';

class SelectLevelScreen extends StatefulWidget {
  final String email;
  final String password;
  final String username;
  final String age;
  final String height;
  final String weight;

  SelectLevelScreen({
    required this.email,
    required this.password,
    required this.username,
    required this.age,
    required this.height,
    required this.weight,
  });

  @override
  _SelectLevelScreenState createState() => _SelectLevelScreenState();
}

class _SelectLevelScreenState extends State<SelectLevelScreen> {
  final _levelController = TextEditingController();

  void _next() {
    final level = _levelController.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectGoalScreen(
          email: widget.email,
          password: widget.password,
          username: widget.username,
          age: widget.age,
          height: widget.height,
          weight: widget.weight,
          level: level,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Level'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _levelController,
              decoration: InputDecoration(labelText: 'Level'),
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