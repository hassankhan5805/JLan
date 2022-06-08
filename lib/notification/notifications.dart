import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
// steps for messaging
// 1. copy key from your firebase project's cloud messaging
// 2. visit main.dart of this project and follow the template as it is
// 4. update fcm //provide your collection name,specify doc id and provide token
// 5. call send notifications

class Notifications {
  initNotify() {
    
  }
  // call to send notification
  //replace the key with your firebae cloud messaging key 'key=={your key}'
  Future<void> sendNotification(
      {required String title,required String body, required String token}) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAmnk6J7E:APA91bF3HihVtLFrhRFcWg_2nN6x6gv9YZJqhYxrD2BMhQTGBaIQLN6yVzgKosyoAcLXcWuhTEmZwB1FF0T04IPTKKxmQBD_KA6k8O6TFQ_61CtdH-e8Gx0ARCZYhLymDC5ABSgd54jQ',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'title': '$title',
              'body': '$body ',
            },
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            },
            'to': '$token',
          },
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<String?> getFCMToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

//call in home or before to update your fcm token
  updateFcm() {
    getFCMToken().then((value) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"token": value});
    });
  }
}
