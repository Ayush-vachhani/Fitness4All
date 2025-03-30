// ignore_for_file: unused_import

import 'package:fitness4all/services/pocketbase_service.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:pocketbase/src/services/file_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';  // Import dio for FormData and MultipartFile

class UserProfileScreen extends StatefulWidget {
  final int age;
  final double height;
  final int weight;
  final String level;

  const UserProfileScreen({
    Key? key,
    required this.age,
    required this.height,
    required this.weight,
    required this.level,
  }) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text("Age: ${widget.age}"),
            Text("Height: ${widget.height}"),
            Text("Weight: ${widget.weight}"),
            Text("Level: ${widget.level}"),
          ],
        ),
      ),
    );
  }
}


extension on FileService {
  // ignore: unused_element
  upload(FormData formData) {}
}