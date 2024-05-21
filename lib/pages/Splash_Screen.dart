// ignore: file_names
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bible_with/pages/Bible_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3500, // set duration to 3 seconds
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/Animation - 1715735578945.json'),
          const Text(
            "David's Bible App",
            style: TextStyle(
              fontSize: 24, // adjust as needed
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      nextScreen: const HomePage(),
      splashTransition: SplashTransition.fadeTransition,
      splashIconSize: double.infinity,
    );
  }
}