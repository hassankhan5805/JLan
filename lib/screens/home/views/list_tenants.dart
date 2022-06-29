import 'package:jlan/models/tenants.dart';
import 'package:jlan/screens/home/views/tenant_home.dart';
import 'package:jlan/services/services.dart';
import 'package:jlan/utils/signout.dart';
import 'package:jlan/utils/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constant/color.dart';

class ListTenants extends StatelessWidget {
  ListTenants({Key? key}) : super(key: key);
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
        child: StreamBuilder<List<tenants>>(
            stream: Services().getAllTenants(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No tenant yet",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                final List<tenants>? data = snapshot.data;
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
                            Get.to(TenantHome(UID: data![index].id));
                          },
                          child: Container(
                            height: 80,
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
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
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 30,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  child: Text(
                                    '${data![index].name}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width: 100,
                                  child: Text(
                                    'Balance : \$${data[index].balance}',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
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
