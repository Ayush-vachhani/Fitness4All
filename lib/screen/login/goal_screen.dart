import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'physique_screen.dart';

class GoalScreen extends StatefulWidget {
  final String username;
  final String email;
  final int age;
  final double height;
  final double weight;
  final String level;
  final XFile? profileImage;

  GoalScreen({
    required this.username,
    required this.email,
    required this.age,
    required this.height,
    required this.weight,
    required this.level,
    required this.profileImage,
  });

  @override
  _GoalScreenState createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  String? _selectedGoal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Goal'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select Your Goal',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              value: _selectedGoal,
              items: ['Fat Loss', 'Weight Gain', 'Muscle Gain', 'Others']
                  .map((goal) => DropdownMenuItem(value: goal, child: Text(goal)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGoal = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your goal';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedGoal != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhysiqueScreen(
                        username: widget.username,
                        email: widget.email,
                        age: widget.age,
                        height: widget.height,
                        weight: widget.weight,
                        level: widget.level,
                        goal: _selectedGoal!,
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