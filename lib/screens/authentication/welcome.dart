import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:jlan/utils/constant/color.dart';

import 'signin.dart';
import 'signup.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final devSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      width: devSize.width,
      height: devSize.height,
      // padding:
      //     const EdgeInsets.only(top: 60.0, bottom: 100, left: 16, right: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to',
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2),
              ),
              Text(
                ' Jlan',
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.green.shade400,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2),
              ),
            ],
          ),
          SizedBox(
            height: 48,
          ),
          Icon(
            Icons.apartment,
            size: 230,
          ),
          SizedBox(
            height: 24,
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => SigninScreen(),
                  duration: Duration(milliseconds: 500),
                  transition: Transition.rightToLeft);
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: ColorsRes.primary),
              child: Center(
                  child: Text('Sign In',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500))),
            ),
          ),
          SizedBox(height: 24.0),
          GestureDetector(
            onTap: () {
              Get.to(() => SignupScreen(),
                  duration: Duration(milliseconds: 500),
                  transition: Transition.rightToLeft);
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                  border: Border.all(color: ColorsRes.primary),
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white),
              child: Center(
                  child: Text('Sign Up',
                      style: TextStyle(
                          color: ColorsRes.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500))),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => SigninScreen(isAdmin: true),
                  duration: Duration(milliseconds: 500),
                  transition: Transition.rightToLeft);
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                  border: Border.all(color: ColorsRes.primary),
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white),
              child: Center(
                  child: Text('Admin login',
                      style: TextStyle(
                          color: ColorsRes.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500))),
            ),
          ),
          Spacer()
        ],
      ),
    ));
  }
}
