import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness4all/services/theme_provider.dart';
import 'package:fitness4all/services/auth_service.dart';
import 'package:fitness4all/screen/home/settings/setting_row.dart';
import 'package:fitness4all/screen/home/settings/profile_screen.dart';
import 'package:fitness4all/screen/home/notification/notification_screen.dart';
import 'package:fitness4all/screen/home/reminder/reminder_screen.dart';
import 'package:fitness4all/screen/home/Meals/meals_screen.dart';
import 'package:fitness4all/common/color_extensions.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final token = await AuthService.getAuthToken();
      if (token != null) {
        await AuthService.fetchUserDetails(AuthService.userDetails!['id'], token);
        if (!mounted) return;
        setState(() {});
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  void _logout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.userDetails;
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.secondary,
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            "assets/img/back.png",
            width: 18,
            height: 18,
          ),
        ),
        title: const Text(
          "Setting",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _errorMessage.isNotEmpty
          ? Center(
              child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                SettingRow(
                  title: "Profile",
                  icon: user?['avatar']?.isNotEmpty == true ? user!['avatar'] : "assets/img/placeholder.png",
                  isIconCircle: true,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfileScreen()),
                    );
                  },
                ),
                SettingRow(
                  title: "Language options",
                  icon: "assets/img/language.png",
                  value: "Eng",
                  onPressed: () {},
                ),
                SettingRow(
                  title: "Health Data",
                  icon: "assets/img/data.png",
                  value: "",
                  onPressed: () {},
                ),
                SettingRow(
                  title: "Notification",
                  icon: "assets/img/notification.png",
                  value: "On",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationScreen()),
                    );
                  },
                ),
                SettingRow(
                  title: "Meals Logger",
                  icon: "assets/img/Meal_logger.png",
                  value: "",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MealsScreen()),
                    );
                  },
                ),
                SettingRow(
                  title: "Refer a Friend",
                  icon: "assets/img/share.png",
                  value: "",
                  onPressed: () {},
                ),
                SettingRow(
                  title: "Feedback",
                  icon: "assets/img/feedback.png",
                  value: "",
                  onPressed: () {},
                ),
                SettingRow(
                  title: "Rate Us",
                  icon: "assets/img/rating.png",
                  value: "",
                  onPressed: () {},
                ),
                SettingRow(
                  title: "Reminder",
                  icon: "assets/img/reminder.png",
                  value: "",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReminderScreen()),
                    );
                  },
                ),
                SettingRow(
                  title: "Level",
                  icon: "assets/img/level.png",
                  value: user?['level'] ?? "",
                  onPressed: () {},
                ),
                SettingRow(
                  title: "Goals",
                  icon: "assets/img/goal.png",
                  value: user?['goal'] ?? "",
                  onPressed: () {},
                ),
                SettingRow(
                  title: "Dark Mode",
                  icon: "assets/img/dark_mode.png",
                  value: "",
                  trailing: Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme(value);
                    },
                  ),
                  onPressed: null,
                ),
                SettingRow(
                  title: "Log Out",
                  icon: "assets/img/logout.png",
                  value: "",
                  onPressed: _logout,
                ),
              ],
            ),
    );
  }
}