import 'package:politech_manager/domain/model/subject_bo.dart';

class ScheduleBO {
  final List<SubjectBO?> subjects;
  final int scheduleType;
  final int fileType;
  final String degree;
  final String semester;
  final String year;
  final int id;

  ScheduleBO(this.subjects, this.scheduleType, this.fileType, this.degree,
      this.semester, this.year, this.id);
}