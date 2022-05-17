
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/binding/classroom_list_binding.dart';
import 'package:politech_manager/app/binding/data_binding.dart';
import 'package:politech_manager/app/binding/degree_list_binding.dart';
import 'package:politech_manager/app/binding/exam_list_binding.dart';
import 'package:politech_manager/app/binding/recover_password_binding.dart';
import 'package:politech_manager/app/binding/schedule_list_binding.dart';
import 'package:politech_manager/app/binding/subject_list_binding.dart';
import 'package:politech_manager/app/views/screens/change_password_screen.dart';
import 'package:politech_manager/app/views/screens/classroom_list_screen.dart';
import 'package:politech_manager/app/views/screens/department_list_screen.dart';
import 'package:politech_manager/app/views/screens/exam_list_screen.dart';
import 'package:politech_manager/app/views/screens/login_screen.dart';
import 'package:politech_manager/app/views/screens/recover_password_screen.dart';
import 'package:politech_manager/app/views/screens/schedule_list_screen.dart';
import 'package:politech_manager/app/views/screens/splash_screen.dart';
import '../binding/change_password_binding.dart';
import '../binding/department_list_binding.dart';
import '../binding/home_binding.dart';
import '../binding/login_binding.dart';
import '../binding/set_new_password_binding.dart';
import '../binding/settings_binding.dart';
import '../binding/sign_in_binding.dart';
import '../binding/splash_binding.dart';
import '../views/screens/data_screen.dart';
import '../views/screens/degree_list_screen.dart';
import '../views/screens/home_screen.dart';
import '../views/screens/set_new_password_screen.dart';
import '../views/screens/settings_screen.dart';
import '../views/screens/sign_in_screen.dart';
import '../views/screens/subject_list_screen.dart';
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
    GetPage(
      name: Routes.degreeList,
      page: () => const DegreeListScreen(),
      binding: DegreeListBinding(),
    ),
    GetPage(
      name: Routes.classroomList,
      page: () => const ClassroomListScreen(),
      binding: ClassroomListBinding(),
    ),
    GetPage(
      name: Routes.departmentList,
      page: () => const DepartmentListScreen(),
      binding: DepartmentListBinding(),
    ),
    GetPage(
      name: Routes.subjectList,
      page: () => const SubjectListScreen(),
      binding: SubjectListBinding(),
    ),
    GetPage(
      name: Routes.examList,
      page: () => const ExamListScreen(),
      binding: ExamListBinding(),
    ),
    GetPage(
      name: Routes.changePassword,
      page: () => ChangePasswordScreen(),
      binding: ChangePasswordBinding(),
    ),
  ];

  static Route? onGenerateRoute(RouteSettings route) {
    if (route.name == Routes.data) {
      return GetPageRoute(
        settings: route,
        page: () => const DataScreen(),
        binding: DataBinding(),
      );
    }

    if (route.name == Routes.scheduleList) {
      return GetPageRoute(
        settings: route,
        page: () => const ScheduleListScreen(),
        binding: ScheduleListBinding(),
      );
    }

    if (route.name == Routes.exam) {
      return GetPageRoute(
        settings: route,
        page: () => const SettingsScreen(),
        binding: SettingsBinding(),
      );
    }

    if (route.name == Routes.setting) {
      return GetPageRoute(
        settings: route,
        page: () => const SettingsScreen(),
        binding: SettingsBinding(),
      );
    }
    return null;
  }
}