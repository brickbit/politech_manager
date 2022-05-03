
import 'package:get/get.dart';
import 'package:politech_manager/app/views/screens/login_screen.dart';
import 'package:politech_manager/app/views/screens/splash_screen.dart';
import '../binding/login_binding.dart';
import '../binding/splash_binding.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
  GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
  ];
}