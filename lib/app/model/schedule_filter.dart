
import 'package:politech_manager/domain/model/subject_bo.dart';

class ScheduleFilter {
  final List<SubjectBO> subjects;
  final int semester;
  final String type;

  ScheduleFilter(this.subjects, this.semester, this.type);

}