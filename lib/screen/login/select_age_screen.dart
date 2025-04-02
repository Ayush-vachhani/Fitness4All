import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'select_height_screen.dart';

class SelectAgeScreen extends StatefulWidget {
  final String username;
  final String email;
  final XFile? profileImage;

  SelectAgeScreen({
    required this.username,
    required this.email,
    required this.profileImage,
  });

  @override
  _SelectAgeScreenState createState() => _SelectAgeScreenState();
}

class _SelectAgeScreenState extends State<SelectAgeScreen> {
  final _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Age'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter Your Age',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _ageController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.cake),
                labelText: 'Age',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_ageController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectHeightScreen(
                        username: widget.username,
                        email: widget.email,
                        age: int.parse(_ageController.text),
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