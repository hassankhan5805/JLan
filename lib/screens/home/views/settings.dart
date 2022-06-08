// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jlan/models/user.dart';
import 'package:jlan/screens/about.dart';
import 'package:jlan/screens/home/views/account.dart';
import 'package:jlan/screens/welcome.dart';
import 'package:jlan/services/auth.dart';
import 'package:jlan/services/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/user.dart';
import '../../../utils/constant/color.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  File? _imageFile;
  bool isFaceID = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final userController = Get.find<UserController>();
  late String? userImage = userController.user.value.photoURL != null
      ? userController.user.value.photoURL
      : null;

  @override
  void initState() {
    if (userController.user.value.imageFile != null) {
      _imageFile = userController.user.value.imageFile;
    }
    super.initState();
  }

  void sendEmail() async {
    final Uri params = Uri(
        scheme: 'mailto',
        path: 'myOwnEmailAddress@gmail.com',
        queryParameters: {
          'subject': 'Default Subject',
          'body': 'Default body'
        });
    String url = params.toString();
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final devSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: devSize.width,
        height: devSize.height,
        padding:
            const EdgeInsets.only(top: 60.0, bottom: 120, left: 16, right: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topLeft,
            colors: [
              Colors.black,
              ColorsRes.primary,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 16,
              ),
              Center(
                child: Stack(fit: StackFit.loose, children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 56,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 52,
                      backgroundImage: _imageFile != null
                          ? FileImage(File(_imageFile!.path))
                          : userImage != null
                              ? NetworkImage(userImage!) as ImageProvider
                              : AssetImage('assets/photo.jpeg'),
                    ),
                  ),
                  Positioned(
                    right: 4,
                    bottom: 2,
                    child: InkWell(
                      onTap: () => _selectImage(context),
                      customBorder: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 16.0,
                        child: Icon(
                          Icons.edit,
                          size: 22,
                          color: ColorsRes.primary,
                        ),
                      ),
                    ),
                  )
                ]),
              ),
              SizedBox(
                height: 16,
              ),
              Center(
                child: Text(
                  "${_auth.currentUser!.displayName}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Center(
                child: Text(
                  '${_auth.currentUser!.email}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                  width: devSize.width,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      tile(
                          title: 'My Account',
                          body: 'Make changes to your account',
                          onTap: () {
                            Get.to(() => AccountScreen(),
                                duration: Duration(milliseconds: 700),
                                transition: Transition.rightToLeft);
                          },
                          leading: Icon(
                            CupertinoIcons.person,
                            color: ColorsRes.primary,
                            size: 26,
                          ),
                          trailing: Icon(CupertinoIcons.forward)),
                      SizedBox(
                        height: 12,
                      ),
                      tile(
                          title: 'Face ID / Touch ID',
                          body: 'Manage your device security',
                          onTap: () {},
                          leading: Icon(
                            CupertinoIcons.lock,
                            color: ColorsRes.primary,
                            size: 26,
                          ),
                          trailing: Switch.adaptive(
                              value: isFaceID,
                              activeColor: ColorsRes.primary,
                              onChanged: (newVal) {
                                setState(() {
                                  isFaceID = newVal;
                                });
                              })),
                      SizedBox(
                        height: 12,
                      ),
                      tile(
                          title: 'Log out',
                          body: 'Further secure your account for safety',
                          onTap: () {
                            userController.user.value = UserModel();
                            UserData().updateElement(
                                "users", "", "token", "null", true);
                            signOut();
                            Get.offAll(WelcomeScreen());
                          },
                          leading: Transform.rotate(
                            angle: pi,
                            child: Icon(
                              CupertinoIcons.square_arrow_left,
                              size: 26,
                              color: ColorsRes.primary,
                            ),
                          ),
                          trailing: Icon(CupertinoIcons.forward)),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  )),
              SizedBox(
                height: 16,
              ),
              Text(
                'More',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              Container(
                  width: devSize.width,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      tile(
                          title: 'Help & Support',
                          body: 'State your querries',
                          onTap: () {
                            sendEmail();
                          },
                          leading: Icon(
                            Icons.help_outline,
                            color: ColorsRes.primary,
                            size: 30,
                          ),
                          trailing: Icon(CupertinoIcons.forward)),
                      SizedBox(
                        height: 12,
                      ),
                      tile(
                          title: 'About App',
                          body: 'About our app',
                          onTap: () {
                            Get.to(() => About(),
                                duration: Duration(milliseconds: 500),
                                transition: Transition.rightToLeft);
                          },
                          leading: Icon(
                            CupertinoIcons.heart,
                            color: ColorsRes.primary,
                            size: 26,
                          ),
                          trailing: Icon(CupertinoIcons.forward)),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  tile(
      {required String title,
      required String body,
      required void Function() onTap,
      required Widget leading,
      required Widget trailing}) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Color.fromRGBO(240, 242, 253, 1),
        radius: 24,
        child: leading,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
      subtitle: Text(
        body,
        style: TextStyle(fontSize: 14),
      ),
      trailing: trailing,
    );
  }

  void _selectImage(BuildContext context) {
    final ImagePicker _picker = ImagePicker();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add image'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text("Take photo"),
                  leading: Icon(Icons.camera_alt_outlined),
                  onTap: () async {
                    final XFile? photo = await _picker.pickImage(
                        source: ImageSource.camera,
                        maxHeight: 480,
                        maxWidth: 640,
                        imageQuality: 15);
                    setState(() {
                      _imageFile = File(photo!.path);
                      userController.user.value.imageFile = _imageFile;
                    });
                    uploadFile();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text("Choose image"),
                  leading: Icon(Icons.photo_outlined),
                  onTap: () async {
                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.gallery,
                      maxHeight: 480,
                      maxWidth: 640,
                      imageQuality: 15,
                    );
                    setState(() {
                      _imageFile = File(image!.path);
                      userController.user.value.imageFile = _imageFile;
                    });
                    uploadFile();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future uploadFile() async {
    String photoUrl;
    String fileName = FirebaseAuth.instance.currentUser!.uid;
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(_imageFile!);
    var storageTaskSnapshot;
    uploadTask.then((value) {
      if (!value.isBlank! || value != "null") {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          // userImage!=null?FirebaseStorage.instance.refFromURL(userImage!).delete():null;
          photoUrl = downloadUrl;
          setState(() {
            userImage = downloadUrl as String;
          });
          FirebaseFirestore.instance
              .collection('users')
              .doc(fileName)
              .update({'photoURL': photoUrl}).then((data) async {
            Get.snackbar(
              "Profile Image",
              "Uploaded",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.white70,
            );
            setState(() {});
          }).catchError((err) {
            Get.snackbar(
              "Profile Image",
              err.toString(),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.white70,
            );
          });
        }, onError: (err) {
          Get.snackbar(
            "Profile Image",
            "Invalid Image",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white70,
          );
        });
      } else {
        Get.snackbar(
          "Profile Image",
          "Invalid Image",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white70,
        );
      }
    }, onError: (err) {
      Get.snackbar(
        "Profile Image",
        err.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white70,
      );
    });
  }
}
