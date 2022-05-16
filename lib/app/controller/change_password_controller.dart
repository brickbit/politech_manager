
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import '../../domain/error/change_password_error.dart';
import '../../domain/error/error_manager.dart';
import '../../domain/repository/user_repository.dart';
import '../navigation/app_routes.dart';
import 'base_controller.dart';

class ChangePasswordController extends BaseController {
  ChangePasswordController(
      {required this.userRepository, required this.errorManager});

  dynamic argumentData = Get.arguments;
  final UserRepository userRepository;
  final ErrorManager errorManager;

  void changePassword(String oldPassword, String newPassword) {
    hideError();
    showProgress();
    userRepository.changePassword(oldPassword,newPassword).fold(
          (left) => _onChangePasswordKo(left),
          (right) => _onChangePasswordOk(),
    );
  }

  void _onChangePasswordOk() {
    hideProgress();
    Get.offNamed(Routes.login);
  }

  void _onChangePasswordKo(ChangePasswordError changePasswordError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertChangePassword(changePasswordError));
  }
}
