import 'package:politech_manager/domain/model/subject_bo.dart';

class ScheduleBO {
  final List<List<List<SubjectBO?>>> subjects;
  final int scheduleType;
  final int fileType;
  final String degree;
  final String year;
  final int id;

  ScheduleBO(this.subjects, this.scheduleType, this.fileType, this.degree,
      this.year, this.id);
}