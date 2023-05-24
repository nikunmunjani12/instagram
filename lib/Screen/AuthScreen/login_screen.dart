import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram/Screen/AuthScreen/phone_number_enter.dart';

import '../HomeScreen/home_screen.dart';

class LoginPageEnter extends StatefulWidget {
  const LoginPageEnter({Key? key}) : super(key: key);

  @override
  State<LoginPageEnter> createState() => _LoginPageEnterState();
}

class _LoginPageEnterState extends State<LoginPageEnter> {
  var formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  bool loading = false;
  bool hidepassword = false;
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 40,
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
                const SizedBox(
                  height: 20,
                ),
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
                const SizedBox(
                  height: 40,
                ),
                loading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          try {
                            UserCredential credential =
                                await auth.signInWithEmailAndPassword(
                                    email: email.text, password: password.text);

                            print('EMAIL${credential.user!.email}');
                            print('UID${credential.user!.uid}');
                            await box.write('userId', credential.user!.uid);
                            setState(() {
                              loading = false;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                          UserId: "${credential.user!.uid}",
                                        )
                                    // ChatTask(uid: credential.user!.uid),
                                    ));
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
                            if (formkey.currentState!.validate()) {}
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 70, vertical: 15),
                            backgroundColor: Colors.blue.shade900),
                        child: const Text("Login"),
                      ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Don't have an account ?"),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Otpenternumber()
                                // RegisterPage(),
                                ),
                          );
                        });
                      },
                      child: Text(
                        "Signup",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
