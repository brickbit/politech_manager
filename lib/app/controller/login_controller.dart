
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/controller/base_controller.dart';
import 'package:politech_manager/domain/error/error_manager.dart';
import 'package:politech_manager/domain/error/login_error.dart';
import '../../../domain/repository/login_repository.dart';
import '../navigation/app_routes.dart';

class LoginController extends BaseController {
  LoginController({required this.loginRepository, required this.errorManager});

  final LoginRepository loginRepository;
  final ErrorManager errorManager;

  void login(String username, String password) {
    hideError();
    showProgress();
    loginRepository.login(username, password).fold(
            (left) => _onLoginKo(left),
            (right) => _onLoginOk()
    );
  }

  void _onLoginKo(LoginError loginError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convert(loginError));
  }

  void _onLoginOk() {
    hideProgress();
    Get.toNamed(Routes.home);
  }
}