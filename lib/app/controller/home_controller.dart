
import 'package:get/get.dart';
import 'package:politech_manager/app/controller/base_controller.dart';
import 'package:politech_manager/app/navigation/app_routes.dart';

class HomeController extends BaseController {

  static HomeController get to => Get.find();

  var currentIndex = 0.obs;

  final pages = <String>[Routes.data, Routes.schedule, Routes.exam, Routes.setting];

  void changePage(int index) {
    currentIndex.value = index;
    Get.toNamed(pages[index], id: 1);
  }
}



