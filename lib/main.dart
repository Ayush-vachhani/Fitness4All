import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fitness4all/screen/home/Main_home/home_screen.dart';
import 'package:fitness4all/services/theme_provider.dart';
import 'package:fitness4all/services/user_provider.dart';
import 'package:fitness4all/common/color_extensions.dart';
import 'package:fitness4all/screen/login/login_screen.dart';
import 'package:fitness4all/screen/login/registration_screen.dart';
import 'package:fitness4all/screen/home/settings/settings_screen.dart'; // Import SettingScreen

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Provide ThemeProvider
        ChangeNotifierProvider(create: (_) => UserProvider()), // Provide UserProvider
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Fitness4All',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: "Poppins",
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                elevation: 0,
                backgroundColor: Colors.transparent,
                titleTextStyle: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                iconTheme: IconThemeData(
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: TColor.primary,
                brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
              ),
              textTheme: TextTheme(
                bodyLarge: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black),
                bodyMedium: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black),
              ),
              useMaterial3: false,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              fontFamily: "Poppins",
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: AppBarTheme(
                elevation: 0,
                backgroundColor: Colors.transparent,
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: TColor.primary,
                brightness: Brightness.dark,
              ),
              textTheme: TextTheme(
                bodyLarge: TextStyle(color: Colors.white),
                bodyMedium: TextStyle(color: Colors.white),
              ),
              useMaterial3: false,
            ),
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: '/login',
            routes: {
              '/login': (context) => LoginScreen(),
              '/home': (context) => HomeScreen(),
              '/register': (context) => RegisterScreen(),
              '/settings': (context) => SettingScreen(),
            },
          );
        },
      ),
    );
  }
}