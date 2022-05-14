import 'classroom_bo.dart';
import 'degree_bo.dart';
import 'department_bo.dart';

class SubjectBO {
  final String name;
  final String acronym;
  final String classGroup;
  final bool seminary;
  final bool laboratory;
  final bool english;
  final int time;
  final int semester;
  final String days;
  final String hours;
  final String turns;
  final ClassroomBO classroom;
  final DepartmentBO department;
  final DegreeBO degree;
  final int color;
  final int id;

  SubjectBO(
      this.name,
      this.acronym,
      this.classGroup,
      this.seminary,
      this.laboratory,
      this.english,
      this.time,
      this.semester,
      this.days,
      this.hours,
      this.turns,
      this.classroom,
      this.department,
      this.degree,
      this.color,
      this.id);
}
