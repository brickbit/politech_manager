
import 'package:politech_manager/data/model/subject_dto.dart';

class ExamDto {
  SubjectDto subject;
  String acronym;
  int semester;
  String date;
  String call;
  String turn;
  int id;

  ExamDto({required this.subject, required this.acronym, required this.semester, required this.date,
      required this.call, required this.turn, required this.id});

  factory ExamDto.fromJson(Map<String, dynamic> json) {
    return ExamDto(
      subject: SubjectDto.fromJson(json['subject']),
      acronym: json['acronym'],
      semester: json['semester'],
      date: json['date'],
      call: json['call'],
      turn: json['turn'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject'] = subject;
    data['acronym'] = acronym;
    data['semester'] = semester;
    data['date'] = date;
    data['call'] = call;
    data['turn'] = turn;
    data['id'] = id;
    return data;
  }
}
