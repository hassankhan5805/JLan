import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jlan/controllers/tenant.dart';

import '../models/tenants.dart';
import '../screens/authentication/welcome.dart';
import '../services/auth.dart';

SignOut() {
  final tenantController = Get.find<TenantController>();
  return IconButton(
      onPressed: () {
        tenantController.tenant.value = tenants();
        tenantController.tenant.value.profileURL = null;
        // Services().updateElement(
        //     "users", "", "token", "null", true);
        signOut();
        Get.offAll(WelcomeScreen());
      },
      icon: Icon(Icons.logout_rounded, color: Colors.white));
}
