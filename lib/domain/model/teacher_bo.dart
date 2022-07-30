
import 'department_bo.dart';

class TeacherBO {
  final String name;
  final DepartmentBO department;
  final int id;

  TeacherBO(
      this.name,
      this.department,
      this.id);

  static TeacherBO mock() {
    return TeacherBO(
        "mock",
        DepartmentBO("Mock", "M", 1),
        1);
  }
}