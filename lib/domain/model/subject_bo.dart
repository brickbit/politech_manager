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
      this.classroom,
      this.department,
      this.degree,
      this.color,
      this.id);

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
        ClassroomBO("C1", Pavilion.central.toString(), "C1", 1),
        DepartmentBO("Mock", "M", 1),
        DegreeBO("Mock", 8, "2021-2022", 1),
        1,
        1);
  }

  SubjectBO copyWith() =>
      SubjectBO(name, acronym, classGroup, seminary, laboratory, english, time, semester, classroom, department, degree, color, id);

  SubjectBO reduceTime() =>
      SubjectBO(name, acronym, classGroup, seminary, laboratory, english, time - 30, semester, classroom, department, degree, color, id);

  SubjectBO addTime() =>
      SubjectBO(name, acronym, classGroup, seminary, laboratory, english, time + 30, semester, classroom, department, degree, color, id);

  SubjectBO updateState(SubjectState newState) =>
      SubjectBO(name, acronym, classGroup, seminary, laboratory, english, time + 30, semester, classroom, department, degree, color, id);

}
