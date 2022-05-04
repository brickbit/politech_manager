
import 'dart:async';

import 'package:get/get.dart';
import 'package:politech_manager/app/controller/base_controller.dart';
import '../navigation/app_routes.dart';

class SplashController extends BaseController {
  SplashController();

  @override
  void onInit() {
    super.onInit();
    Timer(const Duration(milliseconds: 2000), () {
      Get.offNamed(Routes.login);
    });
  }
}