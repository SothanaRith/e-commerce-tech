import 'package:e_commerce_tech/main.dart';
import 'package:e_commerce_tech/screen/language_screen.dart';
import 'package:e_commerce_tech/utils/tap_routes.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState

    Future.delayed(const Duration(seconds: 3), () {
      goOff(this, LanguageScreen());
    });

    super.initState();
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
