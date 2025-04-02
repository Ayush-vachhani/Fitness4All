import 'package:flutter/material.dart';
import 'package:fitness4all/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'select_age_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;
  String _errorMessage = '';

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = pickedImage;
    });
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() {
          _errorMessage = 'Passwords do not match';
        });
        return;
      }

      try {
        await AuthService.register(
          _emailController.text,
          _passwordController.text,
          _usernameController.text,
          '', // Age will be set later
          '', // Height will be set later
          '', // Weight will be set later
          '', // Level will be set later
          '', // Goal will be set later
          _profileImage,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SelectAgeScreen(
              username: _usernameController.text,
              email: _emailController.text,
              profileImage: _profileImage,
            ),
          ),
        );
      } catch (e) {
        debugPrint('Registration Error: $e');
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Create Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? kIsWeb
                            ? Image.network(_profileImage!.path).image
                            : Image.file(io.File(_profileImage!.path)).image
                        : AssetImage("assets/img/placeholder.png"),
                    child: _profileImage == null ? Icon(Icons.camera_alt, size: 50) : null,
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField(_usernameController, 'Username', Icons.person),
                _buildTextField(_emailController, 'Email', Icons.email),
                _buildTextField(_passwordController, 'Password', Icons.lock, obscureText: true),
                _buildTextField(_confirmPasswordController, 'Confirm Password', Icons.lock, obscureText: true),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('Register'),
                ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $labelText';
          }
          return null;
        },
      ),
    );
  }
}