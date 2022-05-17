
import 'package:politech_manager/domain/error/schedule_error_type.dart';

class ScheduleError extends Error {
  final ScheduleErrorType errorType;

  ScheduleError({required this.errorType});
}