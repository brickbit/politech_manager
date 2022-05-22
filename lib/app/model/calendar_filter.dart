
import 'package:politech_manager/domain/model/exam_bo.dart';

class CalendarFilter {
  final List<ExamBO> exams;
  final String startDate;
  final String endDate;
  final String call;
  final String degree;

  CalendarFilter(this.exams, this.startDate, this.endDate, this.call, this.degree);

}