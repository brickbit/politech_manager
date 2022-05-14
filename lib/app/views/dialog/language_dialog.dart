
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void languageDialog(BuildContext context) {
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