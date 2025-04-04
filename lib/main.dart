import 'package:fitness4all/common/color_extensions.dart';
import 'package:fitness4all/screen/login/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitness4all/screen/login/login_screen.dart';
import 'package:fitness4all/services/user_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Fitness4All',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Poppins",
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
              elevation: 0, backgroundColor: Colors.transparent),
          colorScheme: ColorScheme.fromSeed(seedColor: TColor.primary),
          useMaterial3: false,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}