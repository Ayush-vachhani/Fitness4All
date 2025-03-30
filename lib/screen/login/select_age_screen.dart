import 'package:flutter/material.dart';
import 'package:fitness4all/screen/login/select_height_screen.dart';

class SelectAgeScreen extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  SelectAgeScreen({
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  _SelectAgeScreenState createState() => _SelectAgeScreenState();
}

class _SelectAgeScreenState extends State<SelectAgeScreen> {
  final _ageController = TextEditingController();

  void _next() {
    final age = _ageController.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectHeightScreen(
          email: widget.email,
          password: widget.password,
          username: widget.username,
          age: age,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Age'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
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