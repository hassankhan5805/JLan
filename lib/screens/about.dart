import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/constant/color.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
        body: Container(
          height: size.height,
          width: size.width,
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
          child: Center(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.1),
                Text(
                  'About Us',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                SizedBox(height: size.height * 0.1),
                Container(
                  height: size.height * .6,
                  width: size.width * .8,
                  decoration: BoxDecoration(
                    color: ColorsRes.green,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Our mission is to connect likeminded developers and designers.\n\n Find the right people to collab with and build that killer project you always wanted!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
