import 'dart:io' as io;

import 'package:fitness4all/screen/home/settings/setting_row.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fitness4all/common/color_extensions.dart';
import 'package:fitness4all/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  XFile? _profileImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.userDetails ?? {};

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
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? kIsWeb
                          ? Image.network(_profileImage!.path).image
                          : Image.file(io.File(_profileImage!.path)).image
                      : (user['avatar'] != null && user['avatar'].isNotEmpty)
                          ? NetworkImage(user['avatar']) as ImageProvider
                          : const AssetImage("assets/img/placeholder.png"),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['username'] ?? '',
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        user['email'] ?? '',
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        user['level'] ?? '',
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        user['goal'] ?? '',
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SettingRow(
              title: "Complete Task",
              icon: "assets/img/completed_tasks.png",
              value: "3",
              onPressed: null),
          SettingRow(
              title: "Level",
              icon: "assets/img/level.png",
              value: user['level'] ?? '',
              onPressed: null),
          SettingRow(
              title: "Goals",
              icon: "assets/img/goal.png",
              value: user['goal'] ?? '',
              onPressed: null),
          SettingRow(
              title: "Challenges",
              icon: "assets/img/challenges.png",
              value: "4",
              onPressed: null),
          SettingRow(
              title: "Plans",
              icon: "assets/img/calendar.png",
              value: "2",
              onPressed: null),
          SettingRow(
              title: "Fitness Device",
              icon: "assets/img/smartwatch.png",
              value: "Mi",
              onPressed: null),
          SettingRow(
              title: "Refer a Friend",
              icon: "assets/img/share.png",
              value: "",
              onPressed: null),
        ],
      ),
    );
  }
}