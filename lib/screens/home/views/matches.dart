import 'package:jlan/controllers/loading.dart';
import 'package:jlan/models/inbox.dart';
import 'package:jlan/models/user.dart';
import 'package:jlan/services/user.dart';
import 'package:jlan/utils/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constant/color.dart';

class MatchesScreen extends StatelessWidget {
  MatchesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final userController = Get.find<UserController>();
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
        child: StreamBuilder<List<InboxModel>>(
            // stream: ChatService().streamInbox(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No Chat yet",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                final List<InboxModel>? data = snapshot.data;
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
                              CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 36,
                                  backgroundImage:
                                      data![index].usersPicture!.first != null
                                          ? NetworkImage(data[index]
                                              .usersPicture!
                                              .first) as ImageProvider
                                          : AssetImage('assets/phot.jpeg')),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                '${data[index].usersName!.first}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              // Spacer(),
                              // Text(
                              //   '|',
                              //   style: TextStyle(
                              //       fontSize: 36, fontWeight: FontWeight.w300),
                              // ),
                              // Spacer(),
                              // Flexible(
                              //   child: Text(
                              //     "${users[index].languagesOrTools.toString().split('[').last.split(']').first}",
                              //     style: TextStyle(
                              //         fontSize: 18,
                              //         fontWeight: FontWeight.w500),
                              //   ),
                              // ),
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
