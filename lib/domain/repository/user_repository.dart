import 'package:either_dart/either.dart';
import 'package:politech_manager/domain/error/login_error.dart';
import 'package:politech_manager/domain/error/sign_in_error.dart';
import 'package:politech_manager/domain/model/response_sign_in_bo.dart';
import '../error/recover_password_error.dart';
import '../error/set_new_password_error.dart';
import '../model/response_login_bo.dart';
import '../model/response_recover_password_bo.dart';
import '../model/response_set_new_password_bo.dart';

abstract class UserRepository {
  Future<Either<LoginError, ResponseLoginBO>> login(
      String username, String password);
  Future<Either<RecoverPasswordError, ResponseRecoverPasswordBO>>
      recoverPassword(String email);
  Future<Either<SetNewPasswordError, ResponseSetNewPasswordBO>> setNewPassword(
      String password, String token);
  Future<Either<SignInError, ResponseSignInBO>> signIn(
      String user, String email, String password, String repeatPassword);
}
