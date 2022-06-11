import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jlan/models/admin.dart';
import 'package:jlan/services/services.dart';

import '../../controllers/loading.dart';
import '../../services/auth.dart';
import '../../utils/constant/color.dart';
import '../../utils/widgets/loading.dart';
import 'signup.dart';

class IdVerification extends StatefulWidget {
  final bool? isAdmin;
  const IdVerification({Key? key, this.isAdmin}) : super(key: key);

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
  final _formKey = GlobalKey<FormState>();
  TextEditingController apartmentID = TextEditingController();
  String? displayName;
  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.currentUser!.reload();
      displayName = FirebaseAuth.instance.currentUser!.displayName!;
    }

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
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  CupertinoIcons.back,
                  size: 32,
                )),
          ),
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
                          visible: !displayName!.contains("admin"),
                          replacement: StreamBuilder<admin>(
                              stream: Services().getOnlyAdmins(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    children: [
                                      Text(
                                        "Wait Till Owner Allow",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black.withOpacity(.7),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                              "Status : ${snapshot.data!.isAdmin!.contains("true") ? "Approved" : "Pending"}")
                                        ],
                                      )
                                    ],
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(),
                                Text(
                                  'apartment ID verification',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black.withOpacity(.7),
                                  ),
                                ),
                                SizedBox(),
                                // component1(Icons.account_circle_outlined,
                                //     'User name...', false, false,(value) {
                                //   if (value.isEmpty) {
                                //     return 'Please enter your email';
                                //   }
                                //   return null;
                                // },emailController),
                                component1(Icons.edit, 'ID...', false, false,
                                    apartmentID),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 16,
                                    ),
                                    component2(
                                      'Verify',
                                      2.6,
                                      () async {
                                        FocusScope.of(context).unfocus();
                                        if (apartmentID.text.isEmpty)
                                          validator("Field is Required ");
                                        else {
                                          loading.isLoading(true);
                                          FocusScope.of(context).unfocus();
                                          Services()
                                              .apartmentVerification(
                                                  apartmentID.text)
                                              .then((value) {
                                            loading.isLoading(false);
                                          });
                                        }
                                      },
                                    ),
                                    SizedBox(),
                                  ],
                                ),

                                SizedBox(),
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
