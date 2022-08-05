
import 'package:politech_manager/domain/model/subject_bo.dart';

class ScheduleFilter {
  final List<SubjectBO> subjects;
  final String semester;
  final String scheduleType;
  final String degree;
  final String year;
  final bool teacherKnown;

  ScheduleFilter(this.subjects, this.semester, this.scheduleType, this.degree, this.year, this.teacherKnown);

}