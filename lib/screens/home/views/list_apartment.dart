import 'package:jlan/models/admin.dart';
import 'package:jlan/models/apartment.dart';
import 'package:jlan/models/docs.dart';
import 'package:jlan/models/tenants.dart';
import 'package:jlan/services/services.dart';
import 'package:jlan/utils/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constant/color.dart';

class ListApartment extends StatelessWidget {
  ListApartment({Key? key}) : super(key: key);
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
          title: Text('jlan',
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
        child: StreamBuilder<List<apartment>>(
            stream: Services().getAllApartments(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No apartment yet",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                final List<apartment>? data = snapshot.data;
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Get.to(() =>
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
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                '${data![index].id}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
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
