
import 'delete_account_error_type.dart';

class DeleteAccountError extends Error {
  final DeleteAccountErrorType errorType;

  DeleteAccountError({required this.errorType});
}