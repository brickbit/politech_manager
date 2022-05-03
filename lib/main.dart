import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/navigation/app_pages.dart';
import 'app/views/themes/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const EpccApp());
}

class EpccApp extends StatelessWidget {
  const EpccApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: window.locale,
      debugShowCheckedModeBanner: false,
      enableLog: true,
      //logWriterCallback: Logger.write,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      theme: AppThemes.light,
      //translations: LocalizationService(),
    );
  }
}