
import 'package:politech_manager/domain/error/teacher_error_type.dart';

class TeacherError extends Error {
  final TeacherErrorType errorType;

  TeacherError({required this.errorType});
}