
import 'package:intl/intl.dart';

extension DateTimeString on DateTime {
  String dateToString() {
    return toString().split(" ")[0];
  }
}

extension ParseDate on String {
  String parseDate() {
    final DateTime date = DateTime.parse(this);
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date);
  }
}
