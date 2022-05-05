
import 'set_new_password_error_type.dart';

class SetNewPasswordError extends Error {
  final SetNewPasswordErrorType errorType;

  SetNewPasswordError({required this.errorType});
}