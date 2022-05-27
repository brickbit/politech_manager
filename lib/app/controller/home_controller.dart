
import 'package:get/get.dart';
import 'package:politech_manager/app/controller/base_controller.dart';
import 'package:politech_manager/app/navigation/app_routes.dart';

class HomeController extends BaseController {

  static HomeController get to => Get.find();

  dynamic argumentData = Get.arguments;

  final _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  final pages = <String>[Routes.data, Routes.scheduleList, Routes.calendarList, Routes.setting];

  final _currentRoute = Routes.data.obs;

  String get currentRoute => _currentRoute.value;

  @override
  void onInit() {
    _currentRoute.value = argumentData == null ? Routes.data : argumentData['page'];
    _currentIndex.value = pages.indexOf(_currentRoute.value);
    super.onInit();
  }

  void changePage(int index) {
    _currentIndex.value = index;
    Get.toNamed(pages[index], id: 1);
  }
}



