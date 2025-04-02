import 'package:fitness4all/services/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'registration_screen.dart'; // Import the RegistrationScreen

final pb = PocketBase(dotenv.env['SERVER_URL']!);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: const Text("Don't have an account? Create one"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final authData = await pb.collection('users').authWithPassword(_email, _password);

        // Convert RecordModel to Map<String, dynamic>
        final userDetails = {
          'id': authData.record.id,
          'email': authData.record.data['email'],
          'username': authData.record.data['username'],
          'level': authData.record.data['level'],
          'goal': authData.record.data['goal'],
          'avatar': authData.record.data['avatar'],
        };

        // Store user details in UserProvider
        Provider.of<UserProvider>(context, listen: false).setUserDetails(userDetails);

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    }
  }
}