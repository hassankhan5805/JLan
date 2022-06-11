import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:jlan/models/admin.dart';
import 'package:jlan/models/apartment.dart';
import 'package:jlan/models/docs.dart';
import 'package:jlan/models/payments.dart';
import 'package:jlan/screens/home/views/tenant_home.dart';
import '../controllers/tenant.dart';
import '../models/tenants.dart';

class Services {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  static final Services _instance = new Services.internal();
  factory Services() => _instance;
  Services.internal();
  final tenantController = Get.find<TenantController>();

  Stream<List<tenants>>? getAllTenants({bool? filter, bool? collab}) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return _firestore.collection('tenants').snapshots().map((event) {
      // print(event.docs.first.data());
      return event.docs.map((e) => tenants.fromJson(e.data())).toList();
    });
  }

  Stream<tenants> getUserProfile(String? id) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;
    return _firestore.collection("tenants").doc(id).snapshots().map((event) {
      return tenants.fromJson(event.data()!);
    });
  }

  Stream<List<admin>>? getAdmins() {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return _firestore.collection('admin').snapshots().map(
        (event) => event.docs.map((e) => admin.fromJson(e.data())).toList());
  }

  Stream<admin>? getOnlyAdmins() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return _firestore
        .collection('admin')
        .doc(uid)
        .snapshots()
        .map((event) => admin.fromJson(event.data()!));
  }

  Stream<List<apartment>>? getAllApartments() {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return _firestore.collection('apartments').snapshots().map((event) {
      return event.docs.map((e) => apartment.fromJson(e.data())).toList();
    });
  }

  Stream<apartment>? getApartment(String id) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return _firestore.collection('apartments').doc(id).snapshots().map((event) {
      return apartment.fromJson(event.data()!);
    });
  }

  Stream<List<docs>>? getUserDocs(String? id) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return _firestore
        .collection('tenants')
        .doc(id != null ? id : _auth.currentUser!.uid)
        .collection("docs")
        .snapshots()
        .map(
            (event) => event.docs.map((e) => docs.fromJson(e.data())).toList());
  }

  Stream<List<payments>>? getUserPayments(String? id) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return _firestore
        .collection('tenants')
        .doc(id != null ? id : _auth.currentUser!.uid)
        .collection("payments")
        .snapshots()
        .map((event) {
      return event.docs.map((e) => payments.fromJson(e.data())).toList();
    });
  }

  Future<void> setTenant(tenants user) async {
    await _firestore
        .collection('tenants')
        .doc(_auth.currentUser!.uid)
        .set(user.toJson());
  }

  Future<void> setAdmin(admin user) async {
    await _firestore
        .collection('tenants')
        .doc(_auth.currentUser!.uid)
        .set(user.toJson());
  }

  Future<void> setApartment(apartment user) async {
    await _firestore.collection('apartments').doc(user.id).set(user.toJson());
  }

  Future<void> setDoc(docs user, String? UID) async {
    await _firestore
        .collection('tenants')
        .doc(UID)
        .collection("docs")
        .add(user.toJson());
  }

  Future<void> setPayment(payments user, String? UID) async {
    await _firestore
        .collection('tenants')
        .doc(UID)
        .collection("payments")
        .doc(user.date)
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

  updateInnerElement(
    String col,
    String doc,
    String col1,
    String doc1,
    String key,
    var value,
  ) {
    FirebaseFirestore.instance
        .collection(col)
        .doc(doc)
        .collection(col1)
        .doc(doc1)
        .update({key: value});
  }

  apartmentVerification(String id) async {
    var document = await _firestore
        .collection('apartments')
        .where("id", isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        if (value.docs.first["occupiedBy"] == "null") {
          _auth.currentUser!.updateDisplayName(
              _auth.currentUser!.displayName!.split('--').first);

          updateElement(
              "apartments", id, "occupiedBy", _auth.currentUser!.uid, false);
          var x = tenants(
            name: _auth.currentUser!.displayName!.split('--').first,
            email: _auth.currentUser!.email,
            id: _auth.currentUser!.uid,
            apartmentID: id,
            profileURL: "",
            balance: value.docs.first["rent"],
          );
          setTenant(x);

          Get.snackbar("Congrats", "Registration Successful",
              snackPosition: SnackPosition.BOTTOM);
          Get.offAll(TenantHome());
        } else {
          Get.snackbar("Sorry", "Apartment is already occupied",
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar("Sorry", "Apartment does not exist",
            snackPosition: SnackPosition.BOTTOM);
      }
    });
  }

  // Future<tenants> getUserProfileNoStream() async {
  //   FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //   FirebaseAuth _auth = FirebaseAuth.instance;
  //   return await _firestore
  //       .collection("users")
  //       .doc(_auth.currentUser!.uid)
  //       .get()
  //       .then((value) => tenants.fromJson(value.data()!));
  // }
}
