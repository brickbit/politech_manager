
import 'dart:core';
import 'exam_bo.dart';

class CalendarBO {
  final List<ExamBO> exams;
  final String degree;
  final String year;
  final String startDate;
  final String endDate;
  final String call;
  final int id;

  CalendarBO(this.exams, this.degree, this.year, this.startDate,
      this.endDate, this.call, this.id);
}