import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../HomeScreen/home_screen.dart';
import '../Widget/height_width.dart';
import 'image_upload.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, this.abc}) : super(key: key);
  final abc;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  CollectionReference insta =
      FirebaseFirestore.instance.collection('instagram');
  var formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool loading = false;
  bool hidepassword = false;
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Form(
          key: formkey,
          child: Column(
            children: [
              const Text(
                textAlign: TextAlign.center,
                "Set a name for your profile\nthe password",
                style: TextStyle(color: Colors.black38, fontSize: 14),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              TextFormField(
                controller: email,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.mail_outline,
                  ),
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Place Enter User Name';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: height * 0.02),
              TextFormField(
                obscureText: hidepassword,
                controller: password,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidepassword = !hidepassword;
                      });
                    },
                    icon: hidepassword == true
                        ? const Icon(
                            Icons.visibility_off,
                          )
                        : const Icon(
                            Icons.visibility,
                          ),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Place Enter Password';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: height * 0.06,
              ),
              loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        try {
                          UserCredential credential =
                              await auth.createUserWithEmailAndPassword(
                                  email: email.text, password: password.text);

                          print('EMAIL${credential.user!.email}');
                          print('UID${credential.user!.uid}');
                          await box.write('userId', credential.user!.uid);
                          setState(() {
                            loading = false;
                          });

                          insta.doc(credential.user!.uid).set({
                            "Email": email.text,
                            "Password": password.text,
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImagesUpload(
                                  currentuser: credential.user!.uid),
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          print('${e.code}');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${e.message}"),
                            ),
                          );
                          setState(() {
                            loading = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 70, vertical: 15),
                          backgroundColor: Colors.blue),
                      child: const Text("Next"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
