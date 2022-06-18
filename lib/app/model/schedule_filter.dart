
import 'package:politech_manager/domain/model/subject_bo.dart';

class ScheduleFilter {
  final List<SubjectBO> subjects;
  final int semester;
  final String scheduleType;
  final String fileType;
  final String degree;
  final String year;

  ScheduleFilter(this.subjects, this.semester, this.scheduleType, this.fileType, this.degree, this.year);

}