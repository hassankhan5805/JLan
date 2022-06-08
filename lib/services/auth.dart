import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<User?> createAccount(String name, String email, String pass) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  try {
    user = (await auth.createUserWithEmailAndPassword(
            email: email, password: pass))
        .user;
    user!.updateDisplayName(name);
    return user;
  } catch (e) {
    Get.snackbar('Alert', e.toString().split(']').last,
        snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white70,
        );
    return null;
  }
}

Future<User?> signinWithEmail(String email, String pass) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  try {
    user = await auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((value) => value.user);
    return user;
  } catch (e) {
    Get.snackbar('Alert', e.toString().split(']').last,
        snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white70,
        );
    return null;
  }
}

Future<String> signOut() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    await auth.signOut();
    return "null";
  } catch (e) {
    print("Error Signing Out: $e");
    return e.toString();
  }
}
