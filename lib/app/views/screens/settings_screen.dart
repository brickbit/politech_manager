import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../controller/settings_controller.dart';

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
          itemCount: 6,
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
            _languageDialog(context);
          },
        );
      case 1:
        return (Platform.isIOS || Platform.isAndroid || Platform.isMacOS)
            ? ListTile(
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
              )
            : const SizedBox(
                height: 0,
                width: 0,
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
          title: Text('logout'.tr),
          trailing: const Icon(
            Icons.logout,
            color: Colors.grey,
          ),
          onTap: () async {
            controller.logOut();
          },
        );
      case 5:
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

  void _languageDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('selectLanguage'.tr),
        content: SizedBox(
          height: 140,
          child: Column(
            children: [
              ListTile(
                title: const Text('Español'),
                onTap: () {
                  Get.updateLocale(const Locale('es', 'ES'));
                  Get.back();
                },
              ),
              Container(
                height: 1,
                width: 200,
                color: Colors.grey,
              ),
              ListTile(
                title: const Text('English'),
                onTap: () {
                  Get.updateLocale(const Locale('en', 'US'));
                  Get.back();
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: Text('ok'.tr),
          ),
        ],
      ),
    );
  }
}
