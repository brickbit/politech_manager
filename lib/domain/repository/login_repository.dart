
import 'package:either_dart/either.dart';
import 'package:politech_manager/domain/error/login_error.dart';
import '../model/response_login_bo.dart';

abstract class LoginRepository {
  Future<Either<LoginError,ResponseLoginBO>> login(String username, String password);
}