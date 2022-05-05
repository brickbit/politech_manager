import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/controller/base_controller.dart';
import 'package:politech_manager/domain/repository/user_repository.dart';
import '../../domain/error/error_manager.dart';
import '../../domain/error/recover_password_error.dart';
import '../navigation/app_routes.dart';

class RecoverPasswordController extends BaseController {
  RecoverPasswordController(
      {required this.userRepository, required this.errorManager});

  final UserRepository userRepository;
  final ErrorManager errorManager;

  void recoverPassword(String mail) {
    hideError();
    showProgress();
    userRepository.recoverPassword(mail).fold(
        (left) => _onRecoverPasswordKo(left),
        (right) => _onRecoverPasswordOk());
  }

  void _onRecoverPasswordKo(RecoverPasswordError recoverPwdError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertRecoverPwd(recoverPwdError));
  }

  void _onRecoverPasswordOk() {
    hideProgress();
    Get.offNamed(Routes.login);
  }
}
