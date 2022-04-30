
import 'dart:async';

import 'package:get/get.dart';
import '../../navigation/app_routes.dart';

class SplashController extends GetxController {
  SplashController();

  @override
  void onInit() {
    super.onInit();
    Timer(const Duration(milliseconds: 2000), () {
      //Get.toNamed(Routes.login);
    });
  }
}