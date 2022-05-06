
import 'package:get/get.dart';
import 'package:politech_manager/app/binding/recover_password_binding.dart';
import 'package:politech_manager/app/views/screens/login_screen.dart';
import 'package:politech_manager/app/views/screens/recover_password_screen.dart';
import 'package:politech_manager/app/views/screens/splash_screen.dart';
import '../binding/home_binding.dart';
import '../binding/login_binding.dart';
import '../binding/set_new_password_binding.dart';
import '../binding/sign_in_binding.dart';
import '../binding/splash_binding.dart';
import '../views/screens/home_screen.dart';
import '../views/screens/set_new_password_screen.dart';
import '../views/screens/sign_in_screen.dart';
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
    GetPage(
      name: Routes.register,
      page: () => SignInScreen(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: Routes.recoverPassword,
      page: () => RecoverPasswordScreen(),
      binding: RecoverPasswordBinding(),
    ),
    GetPage(
      name: Routes.setNewPassword,
      page: () => SetNewPasswordScreen(),
      binding: SetNewPasswordBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
  ];
}