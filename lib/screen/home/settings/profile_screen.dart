import 'dart:io' as io;
import 'package:fitness4all/screen/login/delete_account_screen.dart';
import 'package:fitness4all/services/pocketbase_service.dart';
import 'package:fitness4all/services/two_factor_auth_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:fitness4all/common/color_extensions.dart';
import 'package:fitness4all/screen/home/settings/setting_row.dart';
import 'package:fitness4all/services/auth_service.dart';
import 'package:fitness4all/screen/login/logout_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  XFile? _profileImage;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _levelController = TextEditingController();
  final _goalController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = AuthService.userDetails;

    if (user != null) {
      _usernameController.text = user['username'] ?? '';
      _emailController.text = user['email'] ?? '';
      _levelController.text = user['level'] ?? '';
      _goalController.text = user['goal'] ?? '';
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile;
      });
    }
  }

  Future<void> _uploadProfilePicture() async {
    try {
      final user = AuthService.userDetails;
      final userId = user?['id'];

      if (userId == null || _profileImage == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid image or user not found.'))
          );
        }
        return;
      }

      final file = kIsWeb
          ? http.MultipartFile.fromBytes(
              'avatar', await _profileImage!.readAsBytes(),
              filename: _profileImage!.name)
          : await http.MultipartFile.fromPath('avatar', _profileImage!.path);

      await pb.collection('users').update(userId, files: [file]);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully.'))
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'))
        );
      }
    }
  }

  Future<void> _saveProfileChanges() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = AuthService.userDetails;
      final userId = user?['id'];

      if (userId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User not found.')));
        }
        return;
      }

      final body = {
        'username': _usernameController.text,
        'email': _emailController.text,
        'level': _levelController.text,
        'goal': _goalController.text,
      };

      await pb.collection('users').update(userId, body: body);

      if (_profileImage != null) {
        await _uploadProfilePicture();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully.')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.userDetails;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
            onPressed: () {
              if (mounted) {
                Navigator.pop(context);
              }
            },
            icon: Image.asset(
              "assets/img/back.png",
              width: 18,
              height: 18,
            )),
        title: Text(
          "Profile",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Logout.performLogout(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? kIsWeb
                            ? Image.network(_profileImage!.path).image
                            : Image.file(io.File(_profileImage!.path)).image
                        : (user?['avatar'] != null && user?['avatar'].isNotEmpty)
                            ? NetworkImage(user?['avatar']) as ImageProvider
                            : const AssetImage("assets/img/placeholder.png"),
                    child: _profileImage == null ? const Icon(Icons.camera_alt, size: 50) : null,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: "Username",
                            labelStyle: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        TextField(
                          controller: _levelController,
                          decoration: InputDecoration(
                            labelText: "Level",
                            labelStyle: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        TextField(
                          controller: _goalController,
                          decoration: InputDecoration(
                            labelText: "Goal",
                            labelStyle: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/img/location.png",
                              width: 12,
                              height: 12,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              "Romania",
                              style: TextStyle(
                                  color: TColor.primaryText, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _saveProfileChanges,
                                child: const Text('Save Changes'),
                              ),
                      ],
                    )),
              ],
            ),
          ),
          SettingRow(
              title: "Complete Task",
              icon: "assets/img/completed_tasks.png",
              value: "3",
              onPressed: () {}),
          SettingRow(
              title: "Level",
              icon: "assets/img/level.png",
              value: _levelController.text,
              onPressed: () {}),
          SettingRow(
              title: "Goals",
              icon: "assets/img/goal.png",
              value: _goalController.text,
              onPressed: () {}),
          SettingRow(
              title: "Challenges",
              icon: "assets/img/challenges.png",
              value: "4",
              onPressed: () {}),
          SettingRow(
              title: "Plans",
              icon: "assets/img/calendar.png",
              value: "2",
              onPressed: () {}),
          SettingRow(
              title: "Fitness Device",
              icon: "assets/img/smartwatch.png",
              value: "Mi",
              onPressed: () {}),
          SettingRow(
              title: "Refer a Friend",
              icon: "assets/img/share.png",
              value: "",
              onPressed: () {}),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text("Delete Account", style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeleteAccountScreen(userId: user?['id'])),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.security, color: Colors.blue),
            title: Text("Two-Factor Authentication"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TwoFactorAuthScreen(userId: user?['id'])),
              );
            },
          ),
        ],
      ),
    );
  }
}