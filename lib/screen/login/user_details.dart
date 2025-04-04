import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:fitness4all/common/color_extensions.dart';
import 'package:fitness4all/screen/home/Main_home/home_screen.dart'; // Import your HomeScreen

class UserDetailsOnboardingScreen extends StatefulWidget {
  const UserDetailsOnboardingScreen({super.key});

  @override
  State<UserDetailsOnboardingScreen> createState() => _UserDetailsOnboardingScreenState();
}

class _UserDetailsOnboardingScreenState extends State<UserDetailsOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final pb = PocketBase('http://10.12.83.187:8090');

  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  String? _selectedLevel;
  String? _selectedGoal;

  final List<String> _fitnessLevels = ['Beginner', 'Intermediate', 'Advanced'];
  final List<String> _fitnessGoals = ['Weight Loss', 'Muscle Gain', 'Fat Loss', 'Others'];

  String _errorMessage = '';
  bool _isLoading = false;

  Future<void> _submitDetails() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedLevel == null || _selectedGoal == null) {
        setState(() => _errorMessage = 'Please select both level and goal');
        return;
      }

      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {


        await pb.collection('User_Details').create(body: {

          "age": _ageController.text,
          "height": _heightController.text,
          "weight": _weightController.text,
          "level": _selectedLevel,
          "goal": _selectedGoal,
        });

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      } on ClientException catch (e) {
        setState(() => _errorMessage = e.response['message'] ?? 'Submission failed');
      } catch (e) {
        setState(() => _errorMessage = 'Error: ${e.toString()}');
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        backgroundColor: TColor.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Help us personalize your experience',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30),
              _buildNumberField(_ageController, 'Age (years)'),
              _buildNumberField(_heightController, 'Height (cm)'),
              _buildNumberField(_weightController, 'Weight (kg)'),
              const SizedBox(height: 20),
              _buildLevelDropdown(),
              const SizedBox(height: 20),
              _buildGoalDropdown(),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColor.primary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Continue', style: TextStyle(fontSize: 18)),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildLevelDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedLevel,
      decoration: InputDecoration(
        labelText: 'Fitness Level',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: _fitnessLevels.map((level) {
        return DropdownMenuItem<String>(
          value: level,
          child: Text(level),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedLevel = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select your fitness level';
        }
        return null;
      },
    );
  }

  Widget _buildGoalDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGoal,
      decoration: InputDecoration(
        labelText: 'Fitness Goal',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: _fitnessGoals.map((goal) {
        return DropdownMenuItem<String>(
          value: goal,
          child: Text(goal),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedGoal = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select your fitness goal';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}