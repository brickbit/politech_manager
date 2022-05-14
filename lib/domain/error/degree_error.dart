

import 'package:politech_manager/domain/error/degree_error_type.dart';

class DegreeError extends Error {
  final DegreeErrorType errorType;

  DegreeError({required this.errorType});
}