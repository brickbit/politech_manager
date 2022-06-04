import 'dart:convert';

import 'exam_dto.dart';

class CalendarDto {
  List<ExamDto?> exams;
  String degree;
  String year;
  String startDate;
  String endDate;
  String call;
  int id;

  CalendarDto(
      {required this.exams,
      required this.degree,
      required this.year,
      required this.startDate,
      required this.endDate,
      required this.call,
      required this.id});

  factory CalendarDto.fromJson(Map<String, dynamic> json) {
    return CalendarDto(
      exams: json['exams'][0] == null ? [] : (json['exams'] as List<dynamic>).map((e) => ExamDto.fromJson(e)).toList(),
      degree: json['degree'],
      year: json['year'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      call: json['call'],
      id: json['id'],
    );
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['exams'] = exams.isEmpty ? [] : exams.map((e) => e?.toJson()).toList();
    data['year'] = year;
    data['degree'] = degree;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['call'] = call;
    data['id'] = id;
    return data;
  }

  @override
  String toString() {
    return "";
  }
}
