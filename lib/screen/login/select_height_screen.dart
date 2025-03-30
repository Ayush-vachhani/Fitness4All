import 'package:flutter/material.dart';
import 'package:fitness4all/screen/login/select_weight_screen.dart';

class SelectHeightScreen extends StatefulWidget {
  final String email;
  final String password;
  final String username;
  final String age;

  SelectHeightScreen({
    required this.email,
    required this.password,
    required this.username,
    required this.age,
  });

  @override
  _SelectHeightScreenState createState() => _SelectHeightScreenState();
}

class _SelectHeightScreenState extends State<SelectHeightScreen> {
  final _heightController = TextEditingController();

  void _next() {
    final height = _heightController.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectWeightScreen(
          email: widget.email,
          password: widget.password,
          username: widget.username,
          age: widget.age,
          height: height,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Height'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: 'Height (cm)'),
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