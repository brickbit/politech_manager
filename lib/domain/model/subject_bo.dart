import 'package:politech_manager/domain/model/subject_state.dart';
import 'package:politech_manager/domain/model/pavilion.dart';

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
  final SubjectState state;


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
      this.id,
      this.state);

  static SubjectBO mock() {
    return SubjectBO(
        "mock",
        "M",
        "A",
        false,
        false,
        false,
        60,
        1,
        "",
        "",
        "",
        ClassroomBO("C1", Pavilion.central.toString(), "C1", 1),
        DepartmentBO("Mock", "M", 1),
        DegreeBO("Mock", 8, "2021-2022", 1),
        1,
        1,
        SubjectState.free);
  }

  SubjectBO copyWith(
      {required String newDay,
        required String newHour,
        required String newTurn}) =>
      SubjectBO(name, acronym, classGroup, seminary, laboratory, english, time, semester, newDay, newHour, newTurn, classroom, department, degree, color, id, state);

  SubjectBO reduceTime() =>
      SubjectBO(name, acronym, classGroup, seminary, laboratory, english, time - 30, semester, days, hours, turns, classroom, department, degree, color, id, state);

  SubjectBO addTime() =>
      SubjectBO(name, acronym, classGroup, seminary, laboratory, english, time + 30, semester, days, hours, turns, classroom, department, degree, color, id, state);

  SubjectBO updateState(SubjectState newState) =>
      SubjectBO(name, acronym, classGroup, seminary, laboratory, english, time + 30, semester, days, hours, turns, classroom, department, degree, color, id, newState);

}
