// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jlan/models/apartment.dart';
import 'package:jlan/models/tenants.dart';
import 'package:jlan/screens/authentication/welcome.dart';
import 'package:jlan/screens/home/views/user_docs.dart';
import 'package:jlan/screens/home/views/user_payments.dart';
import 'package:jlan/services/auth.dart';
import 'package:jlan/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/tenant.dart';
import '../../../controllers/tenant.dart';
import '../../../utils/constant/color.dart';

class TenantHome extends StatefulWidget {
  const TenantHome({Key? key}) : super(key: key);

  @override
  State<TenantHome> createState() => _TenantHomeState();
}

class _TenantHomeState extends State<TenantHome> {
  File? _imageFile;
  bool isFaceID = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final tenantController = Get.find<TenantController>();
  late String? userImage;

  @override
  void initState() {
    if (tenantController.imageFile != null) {
      _imageFile = tenantController.imageFile;
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
            const EdgeInsets.only(top: 30.0, bottom: 40, left: 16, right: 16),
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
          child: StreamBuilder<tenants>(
              stream: Services().getUserProfile(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  userImage = tenantController.tenant.value.profileURL != null
                      ? tenantController.tenant.value.profileURL
                      : null;
                  tenantController.tenant.value = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Balance: ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '\$${tenantController.tenant.value.balance}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600),
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                tenantController.tenant.value = tenants();
                                // Services().updateElement(
                                //     "users", "", "token", "null", true);
                                signOut();
                                Get.offAll(WelcomeScreen());
                              },
                              icon: Icon(Icons.logout_rounded,
                                  color: Colors.white)),
                        ],
                      ),
                      SizedBox(
                        height: 20,
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
                                        ? NetworkImage(userImage!)
                                            as ImageProvider
                                        : AssetImage('assets/images/user.png'),
                              )),
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
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          "${tenantController.tenant.value.name}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Center(
                        child: Text(
                          '${tenantController.tenant.value.email}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 14,
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
                                title: 'apartment ID',
                                body:
                                    '${tenantController.tenant.value.apartmentID}',
                                onTap: () {},
                                leading: Icon(
                                  CupertinoIcons.building_2_fill,
                                  color: ColorsRes.primary,
                                  size: 26,
                                ),
                              ),
                              StreamBuilder<apartment>(
                                  stream: Services().getApartment(
                                      tenantController
                                          .tenant.value.apartmentID!),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final apart =
                                          Get.find<ApartmentController>();
                                      apart.apart.value = snapshot.data!;
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          tile(
                                            title: 'Rent',
                                            body: '${apart.apart.value.rent}',
                                            onTap: () {},
                                            leading: Icon(
                                              CupertinoIcons.money_dollar,
                                              color: ColorsRes.primary,
                                              size: 26,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          tile(
                                            title: 'Incremental',
                                            body:
                                                '${apart.apart.value.incremental}% / Year',
                                            onTap: () {},
                                            leading: Icon(
                                              Icons.arrow_upward,
                                              color: ColorsRes.primary,
                                              size: 26,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          tile(
                                            title: 'Billing Period',
                                            body:
                                                '${apart.apart.value.period} Months',
                                            onTap: () {},
                                            leading: Icon(
                                              Icons.payment,
                                              color: ColorsRes.primary,
                                              size: 26,
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Center(child: Text("No Data"));
                                    }
                                  }),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(120, 50),
                                        primary: ColorsRes.primary,
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        Get.to(UserDocs());
                                      },
                                      child: Text("Docs")),
                                  // Spacer(),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(120, 50),
                                        primary: ColorsRes.primary,
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        Get.to(UserPayments());
                                      },
                                      child: Text("Payments")),
                                ],
                              )
                            ],
                          )),
                    ],
                  );
                } else
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              }),
        ),
      ),
    );
  }

  tile({
    required String title,
    required String body,
    required void Function() onTap,
    required Widget leading,
  }) {
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
      // trailing: trailing,
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
                      tenantController.imageFile = _imageFile;
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
                      tenantController.imageFile = _imageFile;
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
    String profileURL;
    String fileName = FirebaseAuth.instance.currentUser!.uid;
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(_imageFile!);
    var storageTaskSnapshot;
    uploadTask.then((value) {
      if (!value.isBlank! || value != "null") {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          // userImage!=null?FirebaseStorage.instance.refFromURL(userImage!).delete():null;
          profileURL = downloadUrl;
          setState(() {
            userImage = downloadUrl as String;
          });
          FirebaseFirestore.instance
              .collection('tenants')
              .doc(fileName)
              .update({'profileURL': profileURL}).then((data) async {
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
