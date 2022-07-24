
import 'package:politech_manager/data/model/subject_dto.dart';

class ScheduleDto {
  List<SubjectDto?> subjects;
  int scheduleType;
  int fileType;
  String degree;
  String year;
  int id;

  ScheduleDto({required this.subjects, required this.scheduleType, required this.fileType, required this.degree,
      required this.year, required this.id});

  factory ScheduleDto.fromJson(Map<String, dynamic> json) {
    return ScheduleDto(
      subjects: _subjectFromJson(json["subjects"]),
      scheduleType: json['scheduleType'],
      fileType: json['fileType'],
      degree: json['degree'],
      year: json['year'],
      id: json['id'],
    );
  }

  static T? cast<T>(x) => x is T ? x : null;

  static List<SubjectDto?> _subjectFromJson(List<dynamic> json) {
    return json.map((e) => cast<SubjectDto?>(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subjects'] = subjects;
    data['scheduleType'] = scheduleType;
    data['fileType'] = fileType;
    data['degree'] = degree;
    data['year'] = year;
    data['id'] = id;
    return data;
  }

  static List<List<List<SubjectDto?>>> listDynamicTo3DMatrixSubject(List<dynamic> list) {
    return list.map((x) => listDynamicTo2DMatrixSubject(x)).toList();
  }

  static List<List<SubjectDto?>> listDynamicTo2DMatrixSubject(List<dynamic> list) {
    return list.map((x) {
      return listDynamicToListSubject(x);
    }).toList();
  }

  static List<SubjectDto?> listDynamicToListSubject(List<dynamic> list) {
    return list.map((x) {
      if(x != null) {
        return SubjectDto.fromJson(x as Map<String, dynamic>);
      } else {
        return null;
      }
    }).toList();
  }
}
