import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlan/models/payments.dart';
import 'package:jlan/utils/constant/color.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../../models/docs.dart';
import '../../../services/services.dart';

class AddPayment extends StatefulWidget {
  final String? UID;

  const AddPayment({Key? key, this.UID}) : super(key: key);

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  TextEditingController amountController = TextEditingController();
  FilePickerResult? pickedFile;
  bool amountEntered = false;
  String? fileName;

  @override
  Widget build(BuildContext context) {
    final devSize = MediaQuery.of(context).size;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: ColorsRes.primary,
            actions: [
              // IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search)),
              SizedBox(
                width: 8,
              ),
            ],
            title: Text('JLan Payments',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ))),
        body: Container(
          width: devSize.width,
          height: devSize.height,
          // margin: const EdgeInsets.only(top: 60.0),
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
          child: Visibility(
            visible: !amountEntered,
            child: Container(
              padding: const EdgeInsets.all(20),
              height: devSize.height - 400,
              width: devSize.width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(90, 30),
                        primary: ColorsRes.primary,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () {
                        if (amountController.text.isNotEmpty &&
                            amountController.text != null &&
                            amountController.text.isNum) {
                          setState(() {
                            amountEntered = true;
                          });
                        } else {
                          throwError("Please enter a valid amount");
                        }
                      },
                      child: Text("Upload File")),
                ],
              ),
            ),
            replacement: Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: ListTile(
                title: Text("Choose File"),
                leading: Icon(Icons.photo_outlined),
                onTap: () async {
                  pickedFile = await FilePicker.platform.pickFiles();
                  fileName = pickedFile!.files.single.path!.split("/").last;
                  if (pickedFile != null) {
                    var file = File(pickedFile!.files.single.path!);
                    uploadFile(file);
                  }
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ));
  }

//step 2 upload file
  Future uploadFile(File file) async {
    String uid = widget.UID == null
        ? FirebaseAuth.instance.currentUser!.uid
        : widget.UID!;

    String docID = DateTime.now().toString();
    Reference reference =
        FirebaseStorage.instance.ref("/$uid/payments").child(docID);
    UploadTask uploadTask = reference.putFile(file);
    var storageTaskSnapshot;
    uploadTask.then((value) async {
      if (!value.isBlank! || value != "null") {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) async {
          var x = payments(
            amount: amountController.text,
            photoURL: downloadUrl,
            payID: fileName,
            date: DateTime.now().toString(),
            isApproved: "false",
          );
          Services()
              .setPayment(x, uid)
              .then((value) => throwError("File uploaded"));
        }, onError: (err) {
          throwError(err.toString());
        });
      } else {
        throwError("Invalid File");
      }
    }, onError: (err) {
      throwError(err.toString());
    });
  }

  throwError(String a) {
    Get.snackbar(
      "$a",
      "",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white70,
    );
  }
}
