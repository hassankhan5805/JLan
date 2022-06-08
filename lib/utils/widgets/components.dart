import 'package:flutter/material.dart';

import '../constant/color.dart';

Widget component1(
    String hintText, TextEditingController? controller, BuildContext context) {
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
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.edit,
          color: Colors.black.withOpacity(.7),
        ),
        border: InputBorder.none,
        hintMaxLines: 1,
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14, color: Colors.black.withOpacity(.5)),
      ),
    ),
  );
}

Widget component2(String string, double width, VoidCallback voidCallback,
    BuildContext context) {
  return InkWell(
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    onTap: voidCallback,
    child: Container(
      height: 30,
      width: 100,
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
