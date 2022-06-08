import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../controllers/user.dart';
import '../models/user.dart';

class UserData {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  static final UserData _instance = new UserData.internal();
  factory UserData() => _instance;
  UserData.internal();
  Future<void> set(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .set(user.toJson());
  }

  updateElement(String col, String doc, String key, var value, bool currentUser,
      {bool updateName = false}) {
    FirebaseFirestore.instance
        .collection(col)
        .doc(currentUser ? _auth.currentUser!.uid : doc)
        .update({key: value});
    if (updateName) {
      _auth.currentUser!.updateDisplayName(value);
    }
  }

  Stream<List<UserModel>>? get({bool? filter, bool? collab}) {
    final userController = Get.find<UserController>();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    if (filter != null && filter) {
      return _firestore
          .collection('tenants')
          .where('id',
              whereIn: collab!
                  ? userController.user.value.swipe
                  : userController.user.value.matches)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => UserModel.fromJson(doc.data()))
              .toList());
    } else
      return _firestore.collection('users').snapshots().map((event) =>
          event.docs.map((e) => UserModel.fromJson(e.data())).toList());
  }

  // Future<Stream<List<UserModel>>?> getMatchRequest(String uid) async {
  //   FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //   await _firestore.collection("users").doc(uid).get().then((value) {
  //     print(value.get("swipe"));
  //   });

  //   return _firestore
  //       .collection('users')
  //       .where('id', whereIn: matches)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs
  //           .map((doc) => UserModel.fromJson(doc.data()))
  //           .toList());
  // }

  acha() {
    FirebaseFirestore.instance
        .collection('notifications')
        .where({"id": "list"});
  }

  Stream<UserModel> getUserProfile() {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;
    print(_auth.currentUser!.uid);
    return _firestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .snapshots()
        .map((event) => UserModel.fromJson(event.data()!));
  }

  Future<UserModel> getUserProfileNoStream() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;
    return await _firestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) => UserModel.fromJson(value.data()!));
  }
}
