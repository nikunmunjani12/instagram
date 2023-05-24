import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram/Screen/AuthScreen/phone_number_enter.dart';
import 'package:instagram/Screen/AuthScreen/register_screen.dart';
import '../HomeScreen/home_screen.dart';
import '../Widget/communbutton.dart';
import '../Widget/height_width.dart';

class Otp5 extends StatefulWidget {
  const Otp5(
      {Key? key, this.Id, this.token, this.phone, required this.resendigtoken})
      : super(key: key);
  final Id;
  final token;
  final phone;
  final int resendigtoken;
  @override
  State<Otp5> createState() => _Otp5State();
}

class _Otp5State extends State<Otp5> {
  TextEditingController Otp = TextEditingController();
  String? otpcode;
  FirebaseAuth auth = FirebaseAuth.instance;
  int second = 60;
  bool isResend = false;
  void Timerdemo1() {
    Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
      second--;
      if (second == 0) {
        timer.cancel();
        second = 60;
        setState(() {});
        isResend = true;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    Timerdemo1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.1,
            ),
            Center(
              child: Text(
                'Enter tha Confirmation Code We Sent',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Center(
              child: Text(
                '+${widget.phone}',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: height * 0.002,
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Get.to(
                    Otpenternumber(),
                  );
                },
                child: Text(
                  'Change phone number or resend SMS',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.09),
                child: TextField(
                  controller: Otp,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: width * 0.04, vertical: height * 0.022),
                    hintText: 'Confirmation code',
                    hintStyle:
                        TextStyle(color: Color(0xffB6B7B7), fontSize: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Center(
              child: commonbutton(height * 0.060, width * 0.65, () async {
                try {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: widget.Id, smsCode: Otp.text);
                  UserCredential userCredential =
                      await auth.signInWithCredential(credential);
                  print('${userCredential.user!.phoneNumber}');
                  print('${userCredential.user!.uid}');

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Text('data')
                        // HomeScreen(
                        // userId: '${credential}',
                        // ),
                        ),
                  );
                } on FirebaseException catch (e) {
                  print('${e.code}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${e.message}'),
                    ),
                  );
                }
              }, 'Next'),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Center(
                child: Text(
              '${second}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
            )),
            SizedBox(
              height: height * 0.03,
            ),
            isResend
                ? Center(
                    child: commonbutton(height * 0.050, width * 0.30, () async {
                      await auth.verifyPhoneNumber(
                        phoneNumber: '91${widget.phone}',
                        verificationCompleted: (phoneAuthCredential) {
                          print('verifyed');
                        },
                        verificationFailed: (error) {
                          print('ERROR');
                        },
                        codeSent: (verificationId, forceResendingToken) {
                          Get.to(
                            () => Otp5(
                              Id: verificationId,
                              phone: Otp.text,
                              token: forceResendingToken,
                              resendigtoken: 4,
                            ),
                          );
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {
                          print('Time out');
                        },
                        forceResendingToken: widget.token,
                      );

                      isResend = false;
                      Timerdemo1();
                    }, 'Resend OTP'),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
