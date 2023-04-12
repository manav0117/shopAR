import 'dart:async';

import 'package:e_com/authentication/login_page.dart';
import 'package:e_com/screens/onboarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String id = "splash-screen";
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    Timer(const Duration(seconds: 3),
        () => Navigator.pushReplacementNamed(context, OnBoardingScreen.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset("assets/images/logo_1.png")),
    );
  }
}
