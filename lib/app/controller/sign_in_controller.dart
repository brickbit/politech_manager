import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:politech_manager/app/controller/base_controller.dart';
import 'package:politech_manager/domain/error/sign_in_error.dart';
import 'package:politech_manager/domain/repository/user_repository.dart';
import '../../domain/error/error_manager.dart';
import '../../domain/error/recover_password_error.dart';
import '../navigation/app_routes.dart';

class SignInController extends BaseController {
  SignInController(
      {required this.userRepository, required this.errorManager});

  final UserRepository userRepository;
  final ErrorManager errorManager;

  void signIn(String user, String email, String password, String repeatPassword) {
    hideError();
    showProgress();
    userRepository.signIn(user, email, password, repeatPassword).fold(
        (left) => _onSignInKo(left),
        (right) => _onSignInOk(right.message));
  }

  void _onSignInKo(SignInError signInError) {
    hideProgress();
    showError();
    showErrorMessage(errorManager.convertSignIn(signInError));
  }

  void _onSignInOk(String token) {
    hideProgress();
    Get.offNamed(Routes.login);
  }
}
