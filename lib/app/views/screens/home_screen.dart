import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:politech_manager/app/navigation/app_pages.dart';
import '../../controller/home_controller.dart';
import '../../navigation/app_routes.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: Get.nestedKey(1),
        initialRoute: Routes.data,
        onGenerateRoute: AppPages.onGenerateRoute,
      ),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.data_usage_rounded),
              label: 'data'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today),
              label: 'schedule'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.list),
              label: 'exam'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: 'setting'.tr,
            ),
          ],
          currentIndex: controller.currentIndex,
              selectedItemColor: Colors.green,
              unselectedItemColor: Colors.grey,
          onTap: controller.changePage,
        ),
      ),
    );
  }
}
