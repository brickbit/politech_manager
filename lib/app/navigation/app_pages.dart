
import 'package:get/get.dart';
import 'package:politech_manager/app/views/screens/splash_screen.dart';

import '../views/binding/splash_binding.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
  GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
  ];
}