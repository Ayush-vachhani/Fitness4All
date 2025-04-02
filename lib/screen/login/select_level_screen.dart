import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'goal_screen.dart';

class SelectLevelScreen extends StatefulWidget {
  final String username;
  final String email;
  final int age;
  final double height;
  final double weight;
  final XFile? profileImage;

  SelectLevelScreen({
    required this.username,
    required this.email,
    required this.age,
    required this.height,
    required this.weight,
    required this.profileImage,
  });

  @override
  _SelectLevelScreenState createState() => _SelectLevelScreenState();
}

class _SelectLevelScreenState extends State<SelectLevelScreen> {
  String? _selectedLevel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Level'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select Your Level',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              value: _selectedLevel,
              items: ['Beginner', 'Intermediate', 'Advanced']
                  .map((level) => DropdownMenuItem(value: level, child: Text(level)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLevel = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your level';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedLevel != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoalScreen(
                        username: widget.username,
                        email: widget.email,
                        age: widget.age,
                        height: widget.height,
                        weight: widget.weight,
                        level: _selectedLevel!,
                        profileImage: widget.profileImage,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}