
import 'package:politech_manager/domain/error/subject_error_type.dart';

class SubjectError extends Error {
  final SubjectErrorType errorType;

  SubjectError({required this.errorType});
}