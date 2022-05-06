import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../controller/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  buildBottomNavigationMenu(context, landingPageController) {
    return Obx(
      () => BottomNavigationBar(
        showUnselectedLabels: true,
        onTap: landingPageController.changeTabIndex,
        currentIndex: landingPageController.tabIndex.value,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: <BottomNavigationBarItem>[
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: buildBottomNavigationMenu(context, controller),
        body: Obx(
          () => IndexedStack(
            index: controller.tabIndex.value,
            children: [
              Container(),
              Container(),
              Container(),
              Container(),
              /*DataView(),
                    ScheduleView(),
                    SettingsView(),*/
            ],
          ),
        ),
      ),
    );
  }
}
