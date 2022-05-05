
import 'package:either_dart/either.dart';
import 'package:politech_manager/domain/error/login_error.dart';
import '../error/recover_password_error.dart';
import '../error/set_new_password_error.dart';
import '../model/response_login_bo.dart';
import '../model/response_recover_password_bo.dart';
import '../model/response_set_new_password_bo.dart';

abstract class UserRepository {
  Future<Either<LoginError,ResponseLoginBO>> login(String username, String password);
  Future<Either<RecoverPasswordError,ResponseRecoverPasswordBO>> recoverPassword(String email);
  Future<Either<SetNewPasswordError,ResponseSetNewPasswordBO>> setNewPassword(String password, String token);
}