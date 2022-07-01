import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlan/models/admin.dart';
import 'package:jlan/models/apartment.dart';
import 'package:jlan/screens/home/home.dart';
import 'package:jlan/services/services.dart';
import 'package:jlan/utils/signout.dart';
import '../../controllers/loading.dart';
import '../../utils/constant/color.dart';
import '../../utils/widgets/loading.dart';

class IdVerification extends StatefulWidget {
  final bool? isAdmin;
  const IdVerification(this.isAdmin, {Key? key}) : super(key: key);

  @override
  _IdVerificationState createState() => _IdVerificationState();
}

class _IdVerificationState extends State<IdVerification>
    with SingleTickerProviderStateMixin {
  User auth = FirebaseAuth.instance.currentUser!;
  final loading = Get.find<LoadingController>();
  AnimationController? _controller;
  Animation<double>? _opacity;
  Animation<double>? _transform;
  TextEditingController apartmentID = TextEditingController();
  // String? displayName;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.ease,
      ),
    )..addListener(() {
        setState(() {});
      });

    _transform = Tween<double>(begin: 2, end: 1).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    );

    _controller!.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: ColorsRes.primary,
              actions: [SignOut()],
              title: Text('JLan',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ))),
          body: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: SizedBox(
                height: size.height,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black,
                        ColorsRes.primary,
                      ],
                    ),
                  ),
                  child: Opacity(
                    opacity: _opacity!.value,
                    child: Transform.scale(
                      scale: _transform!.value,
                      child: Container(
                        width: size.width * .9,
                        height: size.width * 1.1,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.1),
                              blurRadius: 90,
                            ),
                          ],
                        ),
                        child: Visibility(
                          visible: !widget.isAdmin!,
                          replacement: StreamBuilder<admin>(
                              stream: Services().getOnlyAdmins(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data!.isAdmin!
                                      .contains("true")) {
                                    Future.delayed(Duration(seconds: 2),
                                        () => Get.offAll(AdminPanel()));
                                  }
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Wait Till Owner Allow",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black.withOpacity(.7),
                                        ),
                                      ),
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                "Status : ${snapshot.data!.isAdmin!.contains("true") ? "Approved" : "Pending..."}")
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }),
                          child: ListView(
                            children: [
                              SizedBox(),
                              Center(
                                child: Text(
                                  'Apartment ID Verification\nPlease select your Apartment ID',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black.withOpacity(.7),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 100,
                                width: double.infinity,
                                child: StreamBuilder<List<apartment>>(
                                    stream: Services()
                                        .getAllApartments(filter: true),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data!.isEmpty) {
                                          return Center(
                                            child: Text(
                                              "No apartment yet",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                        }
                                        final List<apartment>? data =
                                            snapshot.data;
                                        return ListView.builder(
                                            itemCount:
                                                snapshot.data!.length + 1,
                                            itemBuilder: (context, index) {
                                              if (index ==
                                                  snapshot.data!.length) {
                                                return SizedBox(
                                                  height: 10,
                                                );
                                              } else
                                                return GestureDetector(
                                                  onTap: () {
                                                    loading.isLoading(true);
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    Services()
                                                        .apartmentVerification(
                                                            data![index]
                                                                .id
                                                                .toString())
                                                        .then((value) {
                                                      loading.isLoading(false);
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16)),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      data![index]
                                                          .id
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black
                                                            .withOpacity(.7),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                            });
                                      } else {
                                        return Center(child: LoadingWidget());
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        LoadingWidget()
      ],
    );
  }

  validator(String? a) {
    Get.snackbar(
      "Alert",
      a!,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Widget component1(IconData icon, String hintText, bool isPassword,
      bool isEmail, TextEditingController? controller) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.width / 8,
      width: size.width / 1.22,
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: size.width / 30),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.black.withOpacity(.8)),
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.black.withOpacity(.7),
          ),
          border: InputBorder.none,
          hintMaxLines: 1,
          hintText: hintText,
          hintStyle:
              TextStyle(fontSize: 14, color: Colors.black.withOpacity(.5)),
        ),
      ),
    );
  }

  Widget component2(String string, double width, VoidCallback voidCallback) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: voidCallback,
      child: Container(
        height: size.width / 8,
        width: size.width / width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // border: Border.all(color: ColorsRes.blue),
          color: ColorsRes.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          string,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
