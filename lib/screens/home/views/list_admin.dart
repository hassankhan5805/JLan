import 'package:jlan/models/admin.dart';
import 'package:jlan/services/services.dart';
import 'package:jlan/utils/signout.dart';
import 'package:jlan/utils/widgets/loading.dart';
import 'package:flutter/material.dart';
import '../../../utils/constant/color.dart';

class ListAdmin extends StatelessWidget {
  ListAdmin({Key? key}) : super(key: key);
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
            SignOut(),
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
        child: StreamBuilder<List<admin>>(
            stream: Services().getAdmins(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No Admin yet",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                final List<admin>? data = snapshot.data;
                return ListView.builder(
                    itemCount: snapshot.data!.length + 1,
                    itemBuilder: (context, index) {
                      if (index == snapshot.data!.length) {
                        return SizedBox(
                          height: 100,
                        );
                      } else
                        return GestureDetector(
                          onTap: () {
                            // Get.to(() =>
                          },
                          child: Container(
                            height: 100,
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16)),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.admin_panel_settings,
                                  size: 50,
                                ),
                                Text(
                                  '${data![index].name}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Status: ${data[index].isAdmin!.contains("true") ? "Approved" : "Pending"}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Visibility(
                                      visible: data[index]
                                          .isAdmin!
                                          .contains("false"),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(90, 30),
                                            primary: ColorsRes.primary,
                                            shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            Services().updateElement(
                                                "admin",
                                                data[index].id!,
                                                "isAdmin",
                                                "true",
                                                false);
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
    );
  }
}
