import 'package:e_commerce_tech/controllers/auth_controller.dart';
import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/language_screen.dart';
import 'package:e_commerce_tech/screen/nav_bar_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkFirstOpen();
  }

  Future<void> _checkFirstOpen() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isFirstTime = prefs.getBool('isFirstTime');
    bool? isLoggedIn = prefs.getBool('isLoggedIn');

    AuthController authController = AuthController();

    // Add small delay to show splash animation
    await Future.delayed(const Duration(seconds: 3));

    if (isFirstTime == null || isFirstTime == true) {
      // First time user
      await prefs.setBool('isFirstTime', false);
      goOff(this, const LanguageScreen());
    } else {
      if (isLoggedIn != null && isLoggedIn == true) {
        await authController.getUser(context: context).then((_) => goOff(this, const MainScreen()),);
        // Already logged in
      } else {
        // Not logged in
        goOff(this, const LoginScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -180,
            left: -50,
            child: Container(
              width: MediaQuery.sizeOf(context).width / 1.5,
              height: MediaQuery.sizeOf(context).width / 1.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).width),
                  border: Border.all(width: 1, color: theme.primaryColor)
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.sizeOf(context).width / 4),
              child: Image.asset("assets/images/logo.png"),
            ),
          ),
          Positioned(
            bottom: -MediaQuery.sizeOf(context).width / 2.5,
            right: -MediaQuery.sizeOf(context).width / 1.5,
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular( MediaQuery.sizeOf(context).width ),
                  border: Border.all(width: 1, color: theme.primaryColor)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
