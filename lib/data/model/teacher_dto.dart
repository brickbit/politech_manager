
import 'department_dto.dart';

class TeacherDto {
  String name;
  DepartmentDto department;
  int id;

  TeacherDto(
      {required this.name,
        required this.department,
        required this.id});

  factory TeacherDto.fromJson(Map<String, dynamic> json) {
    return TeacherDto(
      name: json['name'],
      department: DepartmentDto.fromJson(json['department']),
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['department'] = department;
    data['id'] = id;
    return data;
  }
}
