import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:jlan/models/payments.dart';
import 'package:jlan/screens/home/views/add_payment.dart';
import 'package:jlan/services/services.dart';
import 'package:jlan/utils/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../../../utils/constant/color.dart';

class UserPayments extends StatelessWidget {
  final String? UID;
  UserPayments({Key? key, this.UID}) : super(key: key);
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
            SizedBox(
              width: 8,
            ),
          ],
          title: Text('JLan',
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
        child: StreamBuilder<List<payments>>(
            stream: Services().getUserPayments(UID),
            builder: (context, snapshot) {
              print(snapshot.data);
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No Payments yet",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                final List<payments>? data = snapshot.data;
                print("inside builder");
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          downloadFile(snapshot.data![index].payID,
                              snapshot.data![index].photoURL);
                        },
                        child: Container(
                          height: 100,
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16)),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.payment, color: Colors.black),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Amount: ${data![index].amount}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'Date: ${data[index].date!.split(" ").first}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Status: ${data[index].isApproved!.contains("true") ? "Approved" : "Pending"}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Visibility(
                                    visible: UID != null &&
                                        data[index]
                                            .isApproved!
                                            .contains("false"),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(90, 30),
                                          primary: ColorsRes.primary,
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(30.0),
                                          ),
                                        ),
                                        onPressed: () {
                                          Services().updateInnerElement(
                                              "tenants",
                                              UID!,
                                              "payments",
                                              data[index].date!,
                                              "isApproved",
                                              "true");
                                        },
                                        child: Text("Approve")),
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
            Get.to(AddPayment(
              UID: UID,
            ));
          }),
    );
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
