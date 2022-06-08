import 'package:get/get.dart';

import '../models/user.dart';

class UserController extends GetxController {
  final Rx<UserModel> user = UserModel().obs;
  final Rx<String> pass = ''.obs;
  final Rx<UserModel> profile = UserModel().obs;
}
