
import 'change_password_error_type.dart';

class ChangePasswordError extends Error {
  final ChangePasswordErrorType errorType;

  ChangePasswordError({required this.errorType});
}