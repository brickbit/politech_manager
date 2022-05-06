
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../controller/splash_controller.dart';

class HomeBinding extends Bindings {

  @override
  void dependencies() {
    Get.put(HomeController());
  }

}