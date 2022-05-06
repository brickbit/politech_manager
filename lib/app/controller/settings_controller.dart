
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../domain/error/delete_account_error.dart';
import '../../domain/error/error_manager.dart';
import '../../domain/repository/user_repository.dart';
import '../navigation/app_routes.dart';
import '../views/themes/themes.dart';
import 'base_controller.dart';

class SettingsController extends BaseController {
  SettingsController({required this.userRepository, required this.errorManager});

  final UserRepository userRepository;

  final ErrorManager errorManager;

  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

  final _version = ''.obs;

  final _buildNumber = ''.obs;

  String get version => _version.value;

  String get buildNumber  => _buildNumber.value;

  @override
  void onInit() {
    super.onInit();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      _version.value = packageInfo.version;
      _buildNumber.value = packageInfo.buildNumber;
    });
  }

  void toggleDarkMode() {
    _isDarkMode.value = !_isDarkMode.value;
    if (_isDarkMode.value) {
      Get.changeTheme(AppThemes.dark);
    } else {
      Get.changeTheme(AppThemes.light);
    }
    update();
  }


  void logOut() {
    userRepository.logout();
    Get.offNamed(Routes.login);

  }

  void deleteAccount() {
    hideError();
    showProgress();
    userRepository.deleteUser().fold(
            (left) => _onDeleteAccountKo(left),
            (right) => _onDeleteAccountOk(),
    );
  }

  void _onDeleteAccountOk() {
    hideProgress();
    Get.offNamed(Routes.login);
  }

  void _onDeleteAccountKo(DeleteAccountError deleteAccountError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertDeleteAccount(deleteAccountError));
  }
}