import 'package:jlan/controllers/loading.dart';
import 'package:jlan/models/user.dart';
import 'package:jlan/services/user.dart';
import 'package:jlan/utils/widgets/components.dart';
import 'package:jlan/utils/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constant/color.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List<String> skils = [];
  UserModel? user;
  final loading = Get.find<LoadingController>();
  TextEditingController ideaController = TextEditingController();
  String temp = '';
  bool once = true;

  void dispose() {
    UserData().updateElement("users", "a", "idea", "$temp", true);
    UserData().updateElement("users", "a", "languages", skils, true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final devSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Account',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(CupertinoIcons.back, size: 32)),
      ),
      body: Container(
        width: devSize.width,
        height: devSize.height,
        padding: const EdgeInsets.only(top: 100.0, left: 16, right: 16),
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
          child: StreamBuilder<UserModel>(
              stream: UserData().getUserProfile(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print("snap error ${snapshot.error}");
                }
                if (snapshot.hasData) {
                  loading.isLoading.value = false;

                  var user = snapshot.data;
                  if (once) {
                    temp = user!.idea ?? "";
                    ideaController.text = user.idea ?? "";
                    skils = user.languagesOrTools!;
                    once = false;
                  }
                  // ignore: unused_local_variable
                  var a = user!.idea ?? "";
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 46,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16)),
                                color: user.isDesigner!
                                    ? ColorsRes.pink
                                    : ColorsRes.darkGreen,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 8,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return showDialogue(
                                              context, "Name", "name");
                                        },
                                      );
                                    },
                                    child: Text(
                                      user.name!,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    '|',
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Flexible(
                                    child: Text(
                                      '${skils == null ? 'Languages' : skils.toString().split("[").last.split("]").first.replaceAll(",", "/")}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(16)),
                                  child: SizedBox(
                                    height: 124,
                                    width: 132,
                                    child: user.photoURL != null
                                        ? Image.network(
                                            user.photoURL!,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/photo.jpeg',
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.all(8.0),
                                          height: 80,
                                          child: TextField(
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.zero,
                                                border: InputBorder.none),
                                            maxLines: 4,
                                            textAlign: TextAlign.justify,
                                            controller: ideaController,
                                            onChanged: (value) {
                                              temp = value;
                                            },
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          children: [
                                            // Container(
                                            //   height: 26,
                                            //   width: 52,
                                            //   alignment: Alignment.center,
                                            //   color: Colors.grey,
                                            //   child: Text(
                                            //     'Github',
                                            //     style: TextStyle(color: Colors.white),
                                            //   ),
                                            // ),
                                            Spacer(),
                                            GestureDetector(
                                              child: Image.asset(
                                                'assets/github.png',
                                                height: 36,
                                                width: 36,
                                              ),
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return showDialogue(
                                                        context,
                                                        "Github Public link",
                                                        "github");
                                                  },
                                                );
                                              },
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            GestureDetector(
                                              child: Image.asset(
                                                'assets/linkedin.png',
                                                height: 28,
                                                width: 28,
                                              ),
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return showDialogue(
                                                        context,
                                                        "Linkedin public link",
                                                        "linkedin");
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Badges',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.zero,
                          child: user.isDesigner!
                              ? designerBadges()
                              : developerBadges(),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Offices',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 100,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {});
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return showDialogue(
                                        context, "Company/Uni", "institute",
                                        user1: user);
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Company',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    " ${user.institute!.name!.isEmpty ? "------------" : user.institute!.name}",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 2,
                              height: 20,
                              color: Colors.grey.shade500,
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return showDialogue(
                                        context, "Location", "address",
                                        user1: user);
                                  },
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Location',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return showDialogue(
                                              context, "Address", "address",
                                              user1: user);
                                        },
                                      );
                                    },
                                    child: Text(
                                      '${user.institute!.address ?? '-'}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Ongoing Projects',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return showDialogue(
                                  context, "description", "idea");
                            },
                          );
                        },
                        child: Container(
                          height: 100,
                          alignment: Alignment.center,
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Project-1',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'During office hours',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 2,
                                height: 20,
                                color: Colors.grey.shade500,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Project-2',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'During free time',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  loading.isLoading.value = true;
                  return Center(child: LoadingWidget());
                }
              }),
        ),
      ),
    );
  }

  showDialogue(BuildContext context, String hintText, String key, {var user1}) {
    TextEditingController _controller = TextEditingController();
    var size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
          height: size.height * 0.2,
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
                      if (key == "institute" || key == "address") {
                        var x = Institute(
                          name: key == "institute"
                              ? _controller.text
                              : user1!.institute!.name ?? "",
                          address: key == "institute"
                              ? user1!.institute!.address ?? ""
                              : _controller.text,
                        );
                        user1!.institute = x;
                        var y = x.toJson();
                        UserData().updateElement(
                            "users", "a", "education", y, true,
                            updateName: (key == "name"));
                      } else {
                        UserData().updateElement(
                            "users", "a", key, _controller.text, true,
                            updateName: (key == "name"));
                      }
                      Navigator.pop(context);
                      setState(() {});
                    }, context)
                  ],
                )
              ])),
    );
  }

  developerBadges() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            container(
              'Python',
            ),
            container(
              'Java',
            ),
            container(
              'R',
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            container(
              'SQL',
            ),
            container('JS'),
            container('Swift'),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            container('HTML'),
            container('CSS'),
            container('C++'),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            container('PHP'),
            container('Ruby'),
            container('Flutter'),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            container('React'),
            container('Kotlin'),
            container('Angular'),
          ],
        ),
      ],
    );
  }

  designerBadges() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            container(
              'Adobe',
            ),
            container('Figma'),
            container('AI')
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            container('Sketch'),
            container('Inkscape'),
            container('Photos')
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            container('Video Edi'),
            container('After Ef'),
            container('photosho')
          ],
        ),
        SizedBox(
          height: 8,
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     container(''),
        //     container(''),
        //     container('')
        //   ],
        // ),
        // SizedBox(
        //   height: 8,
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     container('React'),
        //     container('Kotlin'),
        //     container('Angular')
        //   ],
        // ),
      ],
    );
  }

  container(String title) {
    bool isSelected = skils.contains(title);
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected ? skils.remove(title) : skils.add(title);
          print(skils);
        });
      },
      child: Container(
        height: 30,
        width: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.grey,
            borderRadius: BorderRadius.circular(60)),
        child: Text(
          title,
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
