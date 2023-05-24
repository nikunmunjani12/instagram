import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';

import 'package:get/get.dart';
import 'package:instagram/controller/variable.dart';

import '../Screen/AuthScreen/otp_code.dart';

void abc() async {
  try {
    auth.verifyPhoneNumber(
      phoneNumber: '+91${number.text}',
      verificationCompleted: (phoneAuthCredential) {
        log('Verify');
      },
      verificationFailed: (error) {
        log('Error');
      },
      codeSent: (verificationId, forceResendingToken) {
        Get.to(
          Otp5(
            Id: verificationId,
            phone: number.text,
            token: forceResendingToken,
            resendigtoken: 4,
          ),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {
        log('TimeOut');
      },
    );
  } on FirebaseException catch (e) {
    log(e.code);
    Get.snackbar('mistake', '${e.message}');
  }
}
