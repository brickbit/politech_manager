
class DepartmentDto {
  String name;
  String acronym;
  int id;

  DepartmentDto({required this.name, required this.acronym, required this.id});

  factory DepartmentDto.fromJson(Map<String, dynamic> json) {
    return DepartmentDto(
      name: json['name'],
      acronym: json['acronym'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['acronym'] = acronym;
    data['id'] = id;
    return data;
  }

}