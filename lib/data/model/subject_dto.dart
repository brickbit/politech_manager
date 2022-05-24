import 'package:politech_manager/data/model/classroom_dto.dart';
import 'package:politech_manager/data/model/degree_dto.dart';
import 'package:politech_manager/data/model/department_dto.dart';

class SubjectDto {
  String name;
  String acronym;
  String classGroup;
  bool seminary;
  bool laboratory;
  bool english;
  int time;
  int semester;
  String days;
  String hours;
  String turns;
  ClassroomDto classroom;
  DepartmentDto department;
  DegreeDto degree;
  int color;
  int id;

  SubjectDto(
      {required this.name,
      required this.acronym,
      required this.classGroup,
      required this.seminary,
      required this.laboratory,
      required this.english,
      required this.time,
      required this.semester,
      required this.days,
      required this.hours,
      required this.turns,
      required this.classroom,
      required this.department,
      required this.degree,
      required this.color,
      required this.id});

  factory SubjectDto.fromJson(Map<String, dynamic> json) {
    return SubjectDto(
      name: json['name'],
      acronym: json['acronym'],
      classGroup: json['classGroup'],
      seminary: json['seminary'],
      laboratory: json['laboratory'],
      english: json['english'],
      time: json['time'],
      semester: json['semester'],
      days: json['days'] ?? "",
      hours: json['hours'] ?? "",
      turns: json['turns'] ?? "",
      classroom: ClassroomDto.fromJson(json['classroom']),
      department: DepartmentDto.fromJson(json['department']),
      degree: DegreeDto.fromJson(json['degree']),
      color: json['color'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['acronym'] = acronym;
    data['classGroup'] = classGroup;
    data['seminary'] = seminary;
    data['laboratory'] = laboratory;
    data['english'] = english;
    data['time'] = time;
    data['semester'] = semester;
    data['days'] = days;
    data['hours'] = hours;
    data['turns'] = turns;
    data['classroom'] = classroom;
    data['department'] = department;
    data['degree'] = degree;
    data['color'] = color;
    data['id'] = id;
    return data;
  }
}
