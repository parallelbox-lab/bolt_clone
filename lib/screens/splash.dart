import 'dart:async';

import 'package:bolt_clone/screens/mainscreen.dart';
import 'package:bolt_clone/utils/constants.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  _navigationPage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (ctx) => const MainScreen()));
  }

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => _navigationPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
            decoration: const BoxDecoration(color: primaryColor),
            alignment: Alignment.center,
            child: Image.asset("assets/logo.png")),
    );
  }
}
