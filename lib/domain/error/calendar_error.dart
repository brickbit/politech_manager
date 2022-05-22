
import 'calendar_error_type.dart';

class CalendarError extends Error {
  final CalendarErrorType errorType;

  CalendarError({required this.errorType});
}