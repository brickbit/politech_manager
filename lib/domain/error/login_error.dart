
import 'login_error_type.dart';

class LoginError extends Error {
  final LoginErrorType errorType;

  LoginError({required this.errorType});
}