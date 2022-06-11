import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jlan/controllers/loading.dart';
import 'package:jlan/screens/authentication/id_verification.dart';
import 'package:jlan/screens/home/home.dart';
import 'package:jlan/screens/home/views/tenant_home.dart';
import 'package:jlan/screens/authentication/welcome.dart';
import 'package:jlan/services/auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:jlan/controllers/tenant.dart';
import 'firebase_options.dart';
import 'utils/constant/color.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  Get.put(LoadingController());
  Get.put(TenantController());
  Get.put(ApartmentController());
  Get.put(DocController());
  // Notifications().initNotifications();

  runApp(const JlanApp());
}

class JlanApp extends StatelessWidget {
  const JlanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        title: 'Jlan',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
        initialRoute: '/',
      );
    });
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

bool permissionGranted = false;

class SplashScreenState extends State<SplashScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {
        permissionGranted = false;
      });
    }
  }

  @override
  void initState() {
    // signOut();
    _getStoragePermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        // Get.offAll(() => RequestCollab());
      }
    });
    Timer(const Duration(seconds: 3), () {
      if (_auth.currentUser != null) {
        FirebaseAuth.instance.currentUser!.reload().then((value) {
          //owner
          if (_auth.currentUser!.email == "admin@admin.com") {
            Get.offAll(AdminPanel());
          } else if (_auth.currentUser!.displayName!.contains("false")) {
            Get.offAll(IdVerification(false));
          } else if (_auth.currentUser!.displayName!.contains("admin")) {
            FirebaseFirestore.instance
                .collection("admin")
                .doc(_auth.currentUser!.uid)
                .get()
                .then((value) {
              if (value["isAdmin"] == "true") {
                Get.offAll(AdminPanel());
              } else if (value["isAdmin"] == "false") {
                Get.offAll(IdVerification(true));
              } else {
                Get.snackbar("Error", "Please try again");
                signOut();
                Get.to(WelcomeScreen());
              }
            });
          } else {
            Get.offAll(TenantHome());
          }
        });
      } else {
        Get.offAll(WelcomeScreen());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final devSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      width: devSize.width,
      height: devSize.height,
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/jlan2.png",
            width: 300,
            height: 300,
          ),
          Text(
            'Jlan ',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              'Manage your apartment rent here',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 60,
          )
        ],
      ),
    ));
  }
}
