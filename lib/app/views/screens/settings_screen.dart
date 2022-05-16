import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../controller/settings_controller.dart';
import '../dialog/language_dialog.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Obx(
          () => controller.loading
              ? const Center(child: CircularProgressIndicator())
              : _settingsScreen(context),
        );
      }),
    );
  }

  Widget _settingsScreen(BuildContext context) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.redAccent,
      content: Text(controller.errorMsg),
    );
    Future.delayed(Duration.zero, () {
      if (controller.error) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        controller.hideError();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('setting'.tr),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: 7,
          separatorBuilder: (BuildContext context, int index) {
            return const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Divider(color: Colors.grey),
            );
          },
          itemBuilder: (BuildContext context, int index) {
            return _getSettingItem(index, context);
          },
        ),
      ),
    );
  }

  Widget _getSettingItem(int index, BuildContext context) {
    switch (index) {
      case 0:
        return ListTile(
          title: Text('language'.tr),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
          onTap: () async {
            languageDialog(context);
          },
        );
      case 1:
        return ListTile(
                title: Text('darkTheme'.tr),
                trailing: ObxValue(
                  (data) => Switch(
                    value: controller.isDarkMode,
                    activeColor: Colors.green,
                    onChanged: (val) {
                      controller.toggleDarkMode();
                    },
                  ),
                  false.obs,
                ),
                onTap: () {
                  if (Get.isDarkMode) {
                    Get.changeThemeMode(ThemeMode.light);
                  } else {
                    Get.changeThemeMode(ThemeMode.dark);
                  }
                },
              );
      case 2:
        return ListTile(
          title: Text('version'.tr),
          trailing: Obx(() => Text(controller.version)),
        );
      case 3:
        return ListTile(
          title: Text('compilationNumber'.tr),
          trailing: Obx(() => Text(controller.buildNumber)),
        );
      case 4:
        return ListTile(
          title: Text('changePassword'.tr),
          trailing: const Icon(
            Icons.password,
            color: Colors.grey,
          ),
          onTap: () async {
            controller.changePassword();
          },
        );
      case 5:
        return ListTile(
          title: Text('logout'.tr),
          trailing: const Icon(
            Icons.logout,
            color: Colors.grey,
          ),
          onTap: () async {
            controller.logOut();
          },
        );
      case 6:
        return ListTile(
          title: Text('deleteAccount'.tr),
          trailing: const Icon(
            Icons.delete,
            color: Colors.grey,
          ),
          onTap: () async {
            controller.deleteAccount();
          },
        );
      default:
        return const SizedBox();
    }
  }
}
