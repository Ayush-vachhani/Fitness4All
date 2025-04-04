import 'package:fitness4all/services/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'package:provider/provider.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;
import 'package:fitness4all/screen/home/Main_home/home_screen.dart';
import 'package:fitness4all/screen/login/user_details.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;
  String _errorMessage = '';
  bool _isLoading = false;

  // Initialize PocketBase - replace with your server URL
  final pb = PocketBase('http://10.12.83.187:8090');// 10.12.83.187

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = pickedImage;
    });
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() => _errorMessage = 'Passwords do not match');
        return;
      }

      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        // 1. Register with PocketBase
        final userData = {
          'username': _usernameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'passwordConfirm': _confirmPasswordController.text,
          'emailVisibility': true,
        };

        final record = await pb.collection('users').create(body: userData);

        // 2. Upload profile image if exists
        if (_profileImage != null) {
          await pb.collection('users').update(
            record.id,
            files: [
              http.MultipartFile.fromBytes(
                'avatar',
                await io.File(_profileImage!.path).readAsBytes(),
                filename: 'profile.jpg',
              ),
            ],
          );
        }

        // 3. Authenticate the user
        await pb.collection('users').authWithPassword(
          _emailController.text,
          _passwordController.text,
        );

        // 4. Save to local provider
        Provider.of<UserProvider>(context, listen: false).registerUser(
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
          _profileImage?.path,
        );

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserDetailsOnboardingScreen()),
        );
      } on ClientException catch (e) {
        setState(() {
          _errorMessage = e.response['message'] ?? 'Registration failed';
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'An error occurred: ${e.toString()}';
        });
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? Image.file(io.File(_profileImage!.path)).image
                        : const AssetImage("assets/img/placeholder.png"),
                    child: _profileImage == null
                        ? const Icon(Icons.camera_alt, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(_usernameController, 'Username', Icons.person),
                _buildTextField(_emailController, 'Email', Icons.email),
                _buildTextField(_passwordController, 'Password', Icons.lock,
                    obscureText: true),
                _buildTextField(_confirmPasswordController, 'Confirm Password',
                    Icons.lock, obscureText: true),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                    'Register',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, IconData icon,
      {bool obscureText = false}) {
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
          if (labelText == 'Email' && !value.contains('@')) {
            return 'Please enter a valid email';
          }
          if (labelText == 'Password' && value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
      ),
    );
  }
}