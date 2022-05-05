
import 'package:politech_manager/domain/error/recover_password_error.dart';
import 'package:politech_manager/domain/error/set_new_password_error.dart';
import 'login_error.dart';

abstract class ErrorManager {
  String convertLogin(LoginError error);
  String convertRecoverPwd(RecoverPasswordError error);
  String convertNewRecoverPwd(SetNewPasswordError error);
}