import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jlan/models/apartment.dart';
import 'package:jlan/models/tenants.dart';
import 'package:jlan/screens/home/views/user_docs.dart';
import 'package:jlan/screens/home/views/user_payments.dart';
import 'package:jlan/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jlan/utils/signout.dart';
import 'package:jlan/utils/widgets/components.dart';
import '../../../controllers/tenant.dart';
import '../../../utils/constant/color.dart';

class TenantHome extends StatefulWidget {
  final String? UID;
  const TenantHome({Key? key, this.UID}) : super(key: key);

  @override
  State<TenantHome> createState() => _TenantHomeState();
}

class _TenantHomeState extends State<TenantHome> {
  File? _imageFile;
  final tenantController = Get.find<TenantController>();
  TextEditingController? notesController = TextEditingController();
  String? uid;
  @override
  void initState() {
    uid = widget.UID == null
        ? FirebaseAuth.instance.currentUser!.uid
        : widget.UID!;

    if (tenantController.imageFile != null) {
      _imageFile = tenantController.imageFile;
    }
    Services().updatePayments(uid!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final devSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
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
                stream: Services().getUserProfile(uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    tenantController.tenant.value = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Visibility(
                              visible: widget.UID != null,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.arrow_back,
                                    color: Colors.white, size: 22),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Balance:              \$${tenantController.tenant.value.balance}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w400),
                            ),
                            Spacer(),
                            SignOut(),
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
                                      : tenantController.tenant.value
                                                      .profileURL !=
                                                  null &&
                                              !tenantController.tenant.value
                                                  .profileURL!.isEmpty
                                          ? NetworkImage(tenantController
                                              .tenant
                                              .value
                                              .profileURL!) as ImageProvider
                                          : AssetImage(
                                              'assets/images/user.png'),
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
                                              body:
                                                  'Basic:\t${apart.apart.value.rent}\t\t\t\t\tCurrent:\t${rent(int.parse(apart.apart.value.rent!), tenantController.tenant.value.registerOn!, int.parse(apart.apart.value.incremental!), int.parse(apart.apart.value.period!))}',
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
                                              title: 'Next Due Date',
                                              body:
                                                  '${dueDate(tenantController.tenant.value.registerOn!, int.parse(apart.apart.value.period!))}',
                                              onTap: () {},
                                              leading: Icon(
                                                Icons.pending_actions,
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
                                                  '${apart.apart.value.incremental}% / Period',
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
                                            tile(
                                              title: 'Notes',
                                              body:
                                                  '${tenantController.tenant.value.notes}',
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return showDialogue(
                                                        context,
                                                        "Notes",
                                                        "Notes",
                                                        tenantController.tenant
                                                            .value.notes);
                                                  },
                                                );
                                              },
                                              leading: Icon(
                                                Icons.notes_sharp,
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
                                          Get.to(UserDocs(
                                            UID: widget.UID,
                                          ));
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
                                          Get.to(UserPayments(
                                            UID: widget.UID,
                                          ));
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
      ),
    );
  }

  String rent(int rent, DateTime registerOn, int increment, int duration) {
    int period =
        (DateTime.now().difference(registerOn).inDays ~/ 30) ~/ duration;
    for (int i = 0; i < period + 1; i++) {
      rent = (rent + (rent * increment / 100)).round();
    }
    return rent.toString();
  }

  String dueDate(DateTime registerOn, int period) {
    final now = DateTime.now();
    final totalPeriodElapsed = int.parse(
        (now.difference(registerOn).inDays / 30 / period).toStringAsFixed(0));
    final dueDate = registerOn
        .add(Duration(
            days: int.parse((period * 30).toString()) + totalPeriodElapsed + 2))
        .toString();
    return dueDate.split(' ')[0];
  }

  showDialogue(
      BuildContext context, String hintText, String key, String? initialText) {
    TextEditingController _controller = TextEditingController();
    _controller.text = "${initialText ?? ""}";
    var size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
          height: size.height * .5,
          width: size.width * 0.4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 1,
                ),
                Container(
                    width: size.width * 0.6,
                    child: component1(hintText, _controller, context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    component2("Cancel", 30, () {
                      Navigator.pop(context);
                    }, context),
                    SizedBox(
                      width: 10,
                    ),
                    component2("Update", 10, () {
                      Services().updateElement("tenants", widget.UID ?? "",
                          "notes", _controller.text, widget.UID == null);
                      Navigator.pop(context);
                      setState(() {});
                    }, context)
                  ],
                )
              ])),
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
    String fileName = widget.UID != null
        ? widget.UID!
        : FirebaseAuth.instance.currentUser!.uid;
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
            tenantController.tenant.value.profileURL = downloadUrl as String;
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
