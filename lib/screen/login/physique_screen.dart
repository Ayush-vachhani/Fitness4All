import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fitness4all/common/color_extensions.dart';

class PhysiqueScreen extends StatelessWidget {
  final String username;
  final String email;
  final int age;
  final double height;
  final double weight;
  final String level;
  final String goal;
  final XFile? profileImage;

  PhysiqueScreen({
    required this.username,
    required this.email,
    required this.age,
    required this.height,
    required this.weight,
    required this.level,
    required this.goal,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Physique'),
        backgroundColor: TColor.primaryBackground,
        foregroundColor: TColor.primaryText,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: profileImage != null
                      ? kIsWeb
                          ? Image.network(profileImage!.path).image
                          : Image.file(io.File(profileImage!.path)).image
                      : AssetImage("assets/img/placeholder.png"),
                  child: profileImage == null ? Icon(Icons.camera_alt, size: 50) : null,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Your Physique Details',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: TColor.primaryText),
                ),
              ),
              SizedBox(height: 20),
              _buildPhysiqueDetail('Username', username),
              _buildPhysiqueDetail('Email', email),
              _buildPhysiqueDetail('Age', age.toString()),
              _buildPhysiqueDetail('Height', '${height.toStringAsFixed(2)} cm'),
              _buildPhysiqueDetail('Weight', '${weight.toStringAsFixed(2)} kg'),
              _buildPhysiqueDetail('Level', level),
              _buildPhysiqueDetail('Goal', goal),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.buttonBackground,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 18, color: TColor.buttonText),
                  ),
                  child: Text('Finish'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhysiqueDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: TColor.primaryText),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18, color: TColor.primaryText),
          ),
        ],
      ),
    );
  }
}