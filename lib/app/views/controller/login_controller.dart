
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:politech_manager/domain/error/error_manager.dart';
import 'package:politech_manager/domain/error/login_error.dart';
import 'package:politech_manager/domain/model/response_login_bo.dart';
import '../../../domain/repository/login_repository.dart';
import '../../navigation/app_routes.dart';

class LoginController extends GetxController with StateMixin<ResponseLoginBO> {
  LoginController({required this.loginRepository, required this.errorManager});

  final Rx<bool> _loading = false.obs;
  final Rx<bool> _error = false.obs;
  final Rx<String> _errorMsg = "".obs;

  bool get loading => _loading.value;
  bool get error => _error.value;
  String get errorMsg => _errorMsg.value;

  final LoginRepository loginRepository;
  final ErrorManager errorManager;

  void login(String username, String password) {
    _error.value = false;
    _loading.value = true;
    loginRepository.login(username, password).fold(
            (left) => _onLoginKo(left),
            (right) => _onLoginOk()
    );
  }

  void _onLoginKo(LoginError loginError) {
    _loading.value = false;
    _error.value = true;

    _errorMsg.value = errorManager.convert(loginError);
  }

  void _onLoginOk() {
    _loading.value = false;
    Get.toNamed(Routes.home);
  }
}