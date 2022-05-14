
import 'package:politech_manager/domain/error/exam_error_type.dart';

class ExamError extends Error {
  final ExamErrorType errorType;

  ExamError({required this.errorType});
}