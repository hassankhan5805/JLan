import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/loading.dart';

class LoadingWidget extends StatelessWidget {
  LoadingWidget({Key? key}) : super(key: key);
  final loading = Get.find<LoadingController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedContainer(
          duration: Duration(
            milliseconds: 200,
          ),
          width:
              loading.isLoading.value ? MediaQuery.of(context).size.width : 0,
          height:
              loading.isLoading.value ? MediaQuery.of(context).size.height : 0,
          color: Colors.black54.withOpacity(0.5),
          child: Center(
            child: SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        ));
  }
}
