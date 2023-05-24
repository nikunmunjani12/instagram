import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../AuthScreen/login_screen.dart';

import '../AuthScreen/phone_number_enter.dart';
import '../Widget/communbutton.dart';
import '../Widget/height_width.dart';

class OpenInstagram extends StatefulWidget {
  const OpenInstagram({Key? key}) : super(key: key);

  @override
  State<OpenInstagram> createState() => _OpenInstagramState();
}

class _OpenInstagramState extends State<OpenInstagram> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Instagram',
              style: TextStyle(
                  fontFamily: 'Norican',
                  fontSize: height * 0.06,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: height * 0.06),
          commonbutton(
            height * 0.066,
            width * 0.70,
            () {
              Get.to(Otpenternumber());
            },
            'Create new account',
          ),
          SizedBox(height: height * 0.02),
          TextButton(
            onPressed: () {
              Get.to(LoginPageEnter());
            },
            child: Text(
              'Log in',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
