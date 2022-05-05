

import 'sign_in_error_type.dart';

class SignInError extends Error {
  final SignInErrorType errorType;

  SignInError({required this.errorType});
}