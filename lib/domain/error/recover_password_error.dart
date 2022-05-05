
import 'package:politech_manager/domain/error/recover_password_error_type.dart';

class RecoverPasswordError extends Error {
  final RecoverPasswordErrorType errorType;

  RecoverPasswordError({required this.errorType});
}