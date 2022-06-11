import 'dart:io';

import 'package:get/get.dart';
import 'package:jlan/models/apartment.dart';
import 'package:jlan/models/docs.dart';

import '../models/apartment.dart';
import '../models/tenants.dart';

class TenantController extends GetxController {
  final Rx<tenants> tenant = tenants().obs;
  final Rx<String> pass = ''.obs;
  File? imageFile;
  final Rx<tenants> profile = tenants().obs;
}

class ApartmentController extends GetxController {
  final Rx<apartment> apart = apartment().obs;
}

class DocController extends GetxController {
  final Rx<docs> doc = docs().obs;
}
