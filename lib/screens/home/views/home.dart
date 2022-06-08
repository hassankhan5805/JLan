import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jlan/controllers/loading.dart';
import 'package:jlan/notification/notifications.dart';
import 'package:jlan/controllers/user.dart';
import 'package:jlan/models/user.dart';
import 'package:jlan/services/user.dart';
import 'package:jlan/utils/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constant/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int len = 6;
  int noOfItems = 4;
  final userController = Get.find<UserController>();
  String auth = FirebaseAuth.instance.currentUser!.uid;
  getMyData() async {
    userController.user.value = await UserData().getUserProfileNoStream();
    print(userController.user.value.name);
  }

  @override
  void initState() {
    getMyData();
    Notifications().updateFcm();
    super.initState();
  }

 

  @override
  Widget build(BuildContext context) {
    final devSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: ColorsRes.primary,
            actions: [
              IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search)),
              SizedBox(
                width: 8,
              ),
              IconButton(
                  onPressed: () {
                    // Get.to(() => RequestCollab(),
                    //     duration: Duration(milliseconds: 500),
                    //     transition: Transition.rightToLeft);
                  },
                  icon: Icon(CupertinoIcons.bell)),
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
          child: StreamBuilder<List<UserModel>>(
              stream: UserData().get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // loading.isLoading.value = false;

                  if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No Data",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  var users = snapshot.data;
                  noOfItems = users!.length;
                  return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: (devSize.height / 2) - 260),
                          child: SizedBox()
                      // child: SwipeCards(
                      //     matchEngine: MatchEngine(
                      //         swipeItems: List.generate(
                      //             users.length,
                      //             (index) => SwipeItem(likeAction: () {
                      //                   // if user already in matches(inbox), don't add
                      //                   if (userController.user.value.matches!
                      //                       .contains(users[index].id))
                      //                     ;
                      //                   // if user already swiped me then add them to chat instead of notification
                      //                   else if (userController
                      //                       .user.value.swipe!
                      //                       .contains(users[index].id)) {
                      //                     Get.to(ItsMatchScreen(users[index]));
                      //                   }
                      //                   //else all other
                      //                   else if (users[index].id != null &&
                      //                       users[index].id != auth) {
                      //                     postMatches(users[index]);
                      //                   }
                      //                 }))),
                      //     onStackFinished: () {},
                      //     upSwipeAllowed: false,
                      //     fillSpace: false,
                      //     itemBuilder: (context, index) {
                      //       return Container(
                      //         height: 280,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(16),
                      //           color: Colors.white,
                      //         ),
                      //         child: Column(
                      //           mainAxisSize: MainAxisSize.min,
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           mainAxisAlignment: MainAxisAlignment.start,
                      //           children: [
                      //             Container(
                      //               height: 46,
                      //               padding:
                      //                   EdgeInsets.symmetric(horizontal: 8),
                      //               alignment: Alignment.center,
                      //               decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.only(
                      //                     topLeft: Radius.circular(16),
                      //                     topRight: Radius.circular(16)),
                      //                 color: users[index].isDesigner!
                      //                     ? ColorsRes.pink
                      //                     : ColorsRes.darkGreen,
                      //               ),
                      //               child: Center(
                      //                 child: Text(
                      //                   "${users[index].languagesOrTools.toString().split('[').last.split(']').first.replaceAll(',', '/')}",
                      //                   style: TextStyle(
                      //                       fontSize: 16,
                      //                       color: Colors.white,
                      //                       fontWeight: FontWeight.w500),
                      //                 ),
                      //               ),
                      //             ),
                      //             Padding(
                      //               padding: const EdgeInsets.only(
                      //                   left: 16.0, right: 8),
                      //               child: Row(
                      //                 children: [
                      //                   Text(
                      //                     "${users[index].name}",
                      //                     style: TextStyle(
                      //                         fontSize: 18,
                      //                         color: ColorsRes.primary,
                      //                         fontWeight: FontWeight.w600),
                      //                   ),
                      //                   Spacer(),
                      //                   GestureDetector(
                      //                     child: Image.asset(
                      //                       'assets/github.png',
                      //                       height: 40,
                      //                       width: 40,
                      //                     ),
                      //                     onTap: () {
                      //                       if (users[index].github != null) {
                      //                         _launchUrl(users[index].github);
                      //                       }
                      //                     },
                      //                   ),
                      //                   SizedBox(
                      //                     width: 8,
                      //                   ),
                      //                   GestureDetector(
                      //                     child: Image.asset(
                      //                       'assets/linkedin.png',
                      //                       height: 32,
                      //                       width: 32,
                      //                     ),
                      //                     onTap: () {
                      //                       if (users[index].linkedin != null) {
                      //                         _launchUrl(users[index].linkedin);
                      //                       }
                      //                     },
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //             Row(
                      //               children: [
                      //                 SizedBox(
                      //                   height: 124,
                      //                   width: 132,
                      //                   child: users[index].photoURL != null
                      //                       ? Image.network(
                      //                           users[index].photoURL!,
                      //                           fit: BoxFit.cover,
                      //                         )
                      //                       : Image.asset(
                      //                           'assets/photo.jpeg',
                      //                           fit: BoxFit.cover,
                      //                         ),
                      //                 ),
                      //                 Flexible(
                      //                   child: Container(
                      //                     padding: const EdgeInsets.all(8.0),
                      //                     height: 136,
                      //                     child: Text(
                      //                       "${users[index].idea}",
                      //                       overflow: TextOverflow.ellipsis,
                      //                       maxLines: 7,
                      //                       textAlign: TextAlign.justify,
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             Padding(
                      //               padding: const EdgeInsets.symmetric(
                      //                   horizontal: 8.0),
                      //               child: Row(
                      //                 children: [
                      //                   SizedBox(
                      //                     width: 2,
                      //                   ),
                      //                   Icon(
                      //                     Icons.location_on_outlined,
                      //                     size: 20,
                      //                     color: Colors.black,
                      //                   ),
                      //                   SizedBox(
                      //                     width: 4,
                      //                   ),
                      //                   Flexible(
                      //                     child: Text(
                      //                       "${users[index].institute!.address}",
                      //                       maxLines: 2,
                      //                       overflow: TextOverflow.ellipsis,
                      //                       style: TextStyle(
                      //                           fontSize: 15,
                      //                           fontWeight: FontWeight.w500),
                      //                     ),
                      //                   ),
                      //                   SizedBox(
                      //                     width: 16,
                      //                   ),
                      //                 ],
                      //               ),
                      //             )
                      //           ],
                      //         ),
                      //       );
                      //     })
                          );
                } else {
                  return Center(child: Text("No Data Found"));
                }
              }),
        ));
  }

  Future<void> postMatches(UserModel user) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    user.swipe!.add(uid);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.id)
        .update({"swipe": FieldValue.arrayUnion(user.swipe!)}).then((value) {
      Notifications().sendNotification(
          title: "${FirebaseAuth.instance.currentUser!.displayName}",
          body: "Request Collab",
          token: "${user.token}");
    });
  }
}
