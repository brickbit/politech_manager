
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:politech_manager/domain/error/set_new_password_error.dart';
import '../../domain/error/error_manager.dart';
import '../../domain/repository/user_repository.dart';
import '../navigation/app_routes.dart';
import 'base_controller.dart';

class SetNewPasswordController extends BaseController {
  SetNewPasswordController(
      {required this.userRepository, required this.errorManager});

  dynamic argumentData = Get.arguments;
  final UserRepository userRepository;
  final ErrorManager errorManager;
  String token = "";

  @override
  void onInit() {
    token = argumentData['token'];
    super.onInit();
  }

  void setNewPassword(String password) {
    hideError();
    showProgress();
    userRepository.setNewPassword(password, token).fold(
            (left) => _onSetNewPasswordKo(left),
            (right) => _onSetNewPasswordOk());
  }

  void _onSetNewPasswordKo(SetNewPasswordError setNewPwdError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertNewRecoverPwd(setNewPwdError));
  }

  void _onSetNewPasswordOk() {
    hideProgress();
    Get.offNamed(Routes.login);
  }
}
