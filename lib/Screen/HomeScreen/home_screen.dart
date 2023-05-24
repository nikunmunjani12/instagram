import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/Screen/Widget/height_width.dart';
import '../AuthScreen/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.UserId,
  }) : super(key: key);
  final String UserId;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference addinsta =
      FirebaseFirestore.instance.collection('instagram');
  DocumentReference? insta;
  final box = GetStorage();

  @override
  void initState() {
    insta =
        FirebaseFirestore.instance.collection('instagram').doc(widget.UserId);
    super.initState();
  }

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  File? image;
  ImagePicker picker = ImagePicker();
  FirebaseStorage storage = FirebaseStorage.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
            future: insta?.get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.1,
                    ),
                    Center(
                      child: Text(
                        "User Details ",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      'Email:- ${snapshot.data!['Email']}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      'Password:- ${snapshot.data!['Password']}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Center(
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Center(
                      child: Container(
                        height: height * 0.17,
                        width: width * 0.35,
                        child: Image.network(
                          '${snapshot.data!['imagesss']}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Container(
                                  height: height * 0.3,
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          XFile? file = await picker.pickImage(
                                              source: ImageSource.gallery,
                                              imageQuality: 10);
                                          image = File(file!.path);
                                          setState(() {});
                                        },
                                        icon: Icon(Icons.photo),
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue),
                                          onPressed: () async {
                                            await storage
                                                .ref(
                                                    'profile/user1ProfileImage.png')
                                                .putFile(image!)
                                                .then(
                                              (p0) async {
                                                String url = await p0.ref
                                                    .getDownloadURL();
                                                print('URL $url');
                                                addinsta.doc().update({
                                                  "imagesss": url,
                                                });
                                              },
                                            );
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                          child: Text('Update')),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: const Text("Update"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(
                                horizontal: 70, vertical: 13)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        TextButton(
                          onPressed: () async {
                            await box.erase();
                            setState(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPageEnter(),
                                ),
                              );
                            });
                          },
                          child: Text(
                            'LOGOUT',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
