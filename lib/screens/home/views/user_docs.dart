import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jlan/controllers/tenant.dart';
import 'package:jlan/models/docs.dart';
import 'package:jlan/services/services.dart';
import 'package:jlan/utils/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/constant/color.dart';

class UserDocs extends StatefulWidget {
  final String? UID;
  UserDocs({Key? key, this.UID}) : super(key: key);

  @override
  State<UserDocs> createState() => _UserDocsState();
}

class _UserDocsState extends State<UserDocs> {
  @override
  void initState() {
    print(FirebaseAuth.instance.currentUser!.displayName);
  }

  // final tenantController = Get.find<tenantController>();
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
            IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search)),
            SizedBox(
              width: 8,
            ),
          ],
          title: Text('jlan Tech',
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
        child: StreamBuilder<List<docs>>(
            stream: Services().getUserDocs(widget.UID),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No Docs yet",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                final docController = Get.find<DocController>();
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      docController.doc.value = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          print(index);
                          downloadFile(snapshot.data![index].name,
                              snapshot.data![index].docURL);
                        },
                        child: Container(
                          height: 80,
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16)),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Icon(Icons.library_books, color: Colors.black),
                              SizedBox(
                                width: 8,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${docController.doc.value.name}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    docController.doc.value.docID!,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return Center(child: LoadingWidget());
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.black),
        onPressed: () {
          selectFile(context);
        },
      ),
    );
  }

//step 1 file pick
  String? fileName;
  void selectFile(BuildContext context) {
    FilePickerResult? pickedFile;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Document'),
            content: ListTile(
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
          );
        });
  }

//step 2 upload file
  Future uploadFile(File file) async {
    String uid = widget.UID == null
        ? FirebaseAuth.instance.currentUser!.uid
        : widget.UID!;
    String docID = DateTime.now().toString();
    Reference reference =
        FirebaseStorage.instance.ref("/$uid/docs").child(docID);
    UploadTask uploadTask = reference.putFile(file);
    var storageTaskSnapshot;
    uploadTask.then((value) async {
      if (!value.isBlank! || value != "null") {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) async {
          var x = docs(
            name: fileName,
            docURL: downloadUrl,
            docID: docID,
          );
          Services()
              .setDoc(x, uid)
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

//download file from url provided by firebaes storage and extract from collection
  downloadFile(String? fileName, String? myUrl) async {
    HttpClient httpClient = new HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(myUrl!));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        print(bytes.toString());
        openFile(bytes, fileName!);
      } else {
        throwError("Error Occured");
      }
    } catch (ex) {
      throwError("exception $ex");
    }
  }

//file preview
  Future<void> openFile(Uint8List decodedBytes, String docsName) async {
    final root = await getApplicationDocumentsDirectory();
    File("${root.path}/$docsName").create(recursive: true).then((file) async {
      file
          .writeAsBytes(decodedBytes)
          .then((value) async => await OpenFile.open(file.path));
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
