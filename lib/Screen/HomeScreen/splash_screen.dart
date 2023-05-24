import 'dart:async';
import 'package:flutter/material.dart';

import '../Widget/height_width.dart';
import 'instagram.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 3),
      () => Get.to(
        OpenInstagram(),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: height * 0.30,
          ),
          Center(
            child: Image.asset(
              "assets/images/instagramLogo.png",
              scale: height * 0.008,
            ),
          ),
          SizedBox(
            height: height * 0.35,
          ),
          Image.asset(
            'assets/images/meta.png',
            scale: height * 0.003,
          ),
        ],
      ),
    );
  }
}
