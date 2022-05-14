
import 'package:get/get.dart';
import 'package:politech_manager/app/controller/base_controller.dart';
import 'package:politech_manager/app/navigation/app_routes.dart';

class HomeController extends BaseController {

  static HomeController get to => Get.find();

  final _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  final pages = <String>[Routes.data, Routes.schedule, Routes.exam, Routes.setting];

  void changePage(int index) {
    _currentIndex.value = index;
    Get.toNamed(pages[index], id: 1);
  }
}



