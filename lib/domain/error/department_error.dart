
import 'department_error_type.dart';

class DepartmentError extends Error {
  final DepartmentErrorType errorType;

  DepartmentError({required this.errorType});
}