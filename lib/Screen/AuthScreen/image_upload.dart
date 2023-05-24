import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../HomeScreen/home_screen.dart';
import '../Widget/height_width.dart';

class ImagesUpload extends StatefulWidget {
  const ImagesUpload({Key? key, this.currentuser}) : super(key: key);
  final currentuser;

  @override
  State<ImagesUpload> createState() => _ImagesUploadState();
}

class _ImagesUploadState extends State<ImagesUpload> {
  bool loading = false;
  File? image;
  ImagePicker picker = ImagePicker();
  FirebaseStorage storage = FirebaseStorage.instance;
  CollectionReference imageupload =
      FirebaseFirestore.instance.collection('instagram');
  DocumentReference? abc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    abc = FirebaseFirestore.instance
        .collection('instagram')
        .doc(widget.currentuser);
  }

  String? url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: abc?.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              SizedBox(height: height * 0.12),
              GestureDetector(
                onTap: () async {
                  setState(() {});
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        insetPadding: EdgeInsets.symmetric(
                            vertical: height * 0.33, horizontal: width * 0.09),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: height * 0.03),
                            Center(
                              child: Text(
                                'Change profile photo',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 21,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Divider(),
                            Padding(
                              padding: EdgeInsets.only(left: width * 0.03),
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Import from Facebook',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width * 0.03),
                              child: TextButton(
                                onPressed: () async {
                                  XFile? file = await picker.pickImage(
                                      source: ImageSource.camera,
                                      imageQuality: 10);
                                  image = File(file!.path);
                                  setState(() {});
                                },
                                child: Text(
                                  'Take photo',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width * 0.03),
                              child: TextButton(
                                onPressed: () async {
                                  XFile? file = await picker.pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 10);

                                  image = File(file!.path);
                                  setState(() {});
                                },
                                child: Text(
                                  'Choose from library',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 2.5),
                      shape: BoxShape.circle,
                    ),
                    child: image == null
                        ? Center(
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 40,
                              color: Colors.black,
                            ),
                          )
                        : Image.file(
                            image!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.06),
              Text(
                'Add profile photo',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
              SizedBox(height: height * 0.01),
              Text(
                textAlign: TextAlign.center,
                "Add profile photo so your know\nit's you",
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                    fontSize: 17),
              ),
              SizedBox(height: height * 0.02),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 60),
                      backgroundColor: Colors.blue),
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    try {
                      await storage
                          .ref('profile/user1ProfileImage.png')
                          .putFile(image!)
                          .then(
                        (p0) async {
                          url = await p0.ref.getDownloadURL();
                          print('URL $url');
                        },
                      );
                      imageupload.doc(widget.currentuser).update({
                        "imagesss": url,
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HomeScreen(UserId: '${widget.currentuser}'),
                        ),
                      );
                    } on FirebaseAuthException catch (e) {
                      print('${e.code}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${e.message}"),
                          action: SnackBarAction(
                            label: 'undo',
                            onPressed: () {},
                          ),
                        ),
                      );
                      setState(() {
                        loading = false;
                      });
                    }
                  },
                  child: const Text("Register Now"),
                ),
              ),
              SizedBox(height: height * 0.02),
              Text(
                'Skip',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    ));
  }
}
