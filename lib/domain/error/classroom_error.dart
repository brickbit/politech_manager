
import 'classroom_error_type.dart';

class ClassroomError extends Error {
  final ClassroomErrorType errorType;

  ClassroomError({required this.errorType});
}