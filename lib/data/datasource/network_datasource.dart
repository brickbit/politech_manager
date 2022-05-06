import 'package:either_dart/either.dart';
import 'package:politech_manager/domain/error/login_error.dart';
import 'package:politech_manager/domain/error/recover_password_error.dart';
import 'package:politech_manager/domain/error/sign_in_error.dart';
import 'package:politech_manager/domain/model/response_login_bo.dart';
import '../../domain/error/delete_account_error.dart';
import '../../domain/error/set_new_password_error.dart';
import '../../domain/model/response_ok_bo.dart';

abstract class NetworkDataSource {
  Future<Either<LoginError, ResponseLoginBO>> login(
      String username, String password);
  Future<Either<RecoverPasswordError, ResponseOkBO>>
      recoverPassword(String email);
  Future<Either<SetNewPasswordError, ResponseOkBO>> resetPassword(
      String password, String token);
  Future<Either<SignInError, ResponseOkBO>> signIn(
      String user, String email, String password, String repeatPassword);
  void logout();
  Future<Either<DeleteAccountError, ResponseOkBO>> deleteUser();
}
